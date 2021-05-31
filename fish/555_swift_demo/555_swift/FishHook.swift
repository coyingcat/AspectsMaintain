//
//  FishHook.swift
//  FishHook
//
//  Created by roy.cao on 2019/7/5.
//  Copyright © 2019 roy. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import MachO

public struct Rebinding {
    let name: String
    let replacement: UnsafeMutableRawPointer
    var replaced: UnsafeMutableRawPointer?

    init(_ name: String, replacement: UnsafeMutableRawPointer, replaced: inout UnsafeMutableRawPointer?) {
        self.name = name
        self.replacement = replacement
        self.replaced = replaced
    }
}

private var currentRebinding: Rebinding? = nil

public func rebindSymbol(_ name: String, replacement: UnsafeMutableRawPointer, replaced: inout UnsafeMutableRawPointer?) {
    let rebinding = Rebinding(name, replacement: replacement, replaced: &replaced)
    _rebindSymbol(rebinding)
    replaced = currentRebinding?.replaced
}

public func _rebindSymbol(_ rebinding: Rebinding) {
    // 判断是不是,第一次调用
    if currentRebinding == nil {
        currentRebinding = rebinding
        // 第一次调用需要注册, dyld 关于镜像文件的回调
        _dyld_register_func_for_add_image(rebindSymbolForImage)
    } else {
        currentRebinding = rebinding
        // 遍历已经加载的 image, 进行 hook
        for i in 0..<_dyld_image_count() {
            rebindSymbolForImage(_dyld_get_image_header(i), _dyld_get_image_vmaddr_slide(i))
        }
    }
}



/*
 进行 hook

 主要从 Macho-O 文件中找到对应的懒加载符号段、非懒加载符号段、符号表、动态符号表和字符串表

 因为苹果的设计，不能直接得到需要的内容，只能沿着相应的路径一步步寻找，得到想要的值。

 查表比较繁琐
 
 */
func rebindSymbolForImage(_ mh: UnsafePointer<mach_header>?, _ slide:Int) {
    guard let mh = mh else { return }
    // 定义几个变量，从 MachO 里面找
    var curSegCmd: UnsafeMutablePointer<segment_command_64>!
    var linkeditSegment: UnsafeMutablePointer<segment_command_64>!
    var symtabCmd: UnsafeMutablePointer<symtab_command>!
    var dysymtabCmd: UnsafeMutablePointer<dysymtab_command>!
    // cur 是一个指针，存放的地址 = pageZero + ASLR的值 + mach_header_64 的大小，
    // 可得 Load Commands 的地址
    var cur = UnsafeRawPointer(mh).advanced(by: MemoryLayout<mach_header_64>.stride)
    // 遍历 commands ,
    // 确定 linkedit、symtab、dysymtab
    // 这几个 command 的位置
    for _: UInt32 in 0 ..< mh.pointee.ncmds {
        curSegCmd = UnsafeMutableRawPointer(mutating: cur).assumingMemoryBound(to: segment_command_64.self)
        cur = UnsafeRawPointer(cur).advanced(by: Int(curSegCmd.pointee.cmdsize))

        if curSegCmd.pointee.cmd == LC_SEGMENT_64 {
            let segname = String(cString: &curSegCmd.pointee.segname, maxLength: 16)
            if segname == SEG_LINKEDIT {
                linkeditSegment = curSegCmd
            }
        } else if curSegCmd.pointee.cmd == LC_SYMTAB {
            symtabCmd = UnsafeMutableRawPointer(mutating: curSegCmd).assumingMemoryBound(to: symtab_command.self)
        } else if curSegCmd.pointee.cmd == LC_DYSYMTAB {
            dysymtabCmd = UnsafeMutableRawPointer(mutating: curSegCmd).assumingMemoryBound(to: dysymtab_command.self)
        }
    }
    // 刚才获取的，有一项为空, 直接返回
    guard linkeditSegment != nil, symtabCmd != nil, dysymtabCmd != nil else {
        return
    }
    // 链接时程序的基址 = __LINKEDIT.VM_Address + silde的改变值 -__LINKEDIT.File_Offset
    let linkeditBase = slide + Int(linkeditSegment.pointee.vmaddr) - Int(linkeditSegment.pointee.fileoff)
    
    // 符号表的地址 = 基址 + 符号表偏移量
    let symtab = UnsafeMutablePointer<nlist_64>(bitPattern: linkeditBase + Int(symtabCmd.pointee.symoff))
    
    // 字符串表的地址 = 基址 + 字符串表偏移量
    let strtab = UnsafeMutablePointer<UInt8>(bitPattern: linkeditBase + Int(symtabCmd.pointee.stroff))
    
    // 动态符号表地址 = 基址 + 动态符号表偏移量
    let indirectSymtab = UnsafeMutablePointer<UInt32>(bitPattern: linkeditBase + Int(dysymtabCmd.pointee.indirectsymoff))

    guard let _symtab = symtab, let _strtab = strtab, let _indirectSymtab = indirectSymtab else {
        return
    }
    // 重置 cur,
    // 回到 loadCommand 开始的位置
    cur = UnsafeRawPointer(mh).advanced(by: MemoryLayout<mach_header_64>.stride)
    for _: UInt32 in 0 ..< mh.pointee.ncmds {
        curSegCmd = UnsafeMutableRawPointer(mutating: cur).assumingMemoryBound(to: segment_command_64.self)
        cur = UnsafeRawPointer(cur).advanced(by: Int(curSegCmd.pointee.cmdsize))

        if curSegCmd.pointee.cmd == LC_SEGMENT_64 {
            let segname = String(cString: &curSegCmd.pointee.segname, maxLength: 16)
            if segname == SEG_DATA {
                // 寻找到 data 段
                for j in 0..<curSegCmd.pointee.nsects {
                    // 遍历每一个 section header
                    let cur = UnsafeRawPointer(curSegCmd).advanced(by: MemoryLayout<segment_command_64>.size + Int(j))
                    
                    // 看错了，不是乘法，是强转
                    // let cur = UnsafeRawPointer(curSegCmd).advanced(by: MemoryLayout<segment_command_64>.size * MemoryLayout<section_64>.size + Int(j))
                    
                    let section = UnsafeMutableRawPointer(mutating: cur).assumingMemoryBound(to: section_64.self)
                    if section.pointee.flags == S_LAZY_SYMBOL_POINTERS || section.pointee.flags == S_NON_LAZY_SYMBOL_POINTERS {
                        // 找懒加载表
                        // 和非懒加载表
                        performRebindingWithSection(section, slide: slide, symtab: _symtab, strtab: _strtab, indirectSymtab: _indirectSymtab)
                    }
                }
            }
        }
    }
}





func performRebindingWithSection(_ section: UnsafeMutablePointer<section_64>,
                                 slide: Int,
                                 symtab: UnsafeMutablePointer<nlist_64>,
                                 strtab: UnsafeMutablePointer<UInt8>,
                                 indirectSymtab: UnsafeMutablePointer<UInt32>) {
    guard var rebinding = currentRebinding, let symbolBytes = rebinding.name.data(using: String.Encoding.utf8)?.map({ $0 }) else {
        return
    }
    //   nl_symbol_ptr ( 加载表 ) 和 la_symbol_ptr  （ 懒加载表 ）section 中的 reserved1 字段,
    //   表示对应的 indirect symbol table 起始的 index
    let indirectSymbolIndices = indirectSymtab.advanced(by: Int(section.pointee.reserved1))
    
    
    //  slide + section->addr ，  就是
    // 符号对应的函数实现的数组，
    // 即找到了相应的 __nl_symbol_ptr 和 __la_symbol_ptr 表里面的函数指针，可去找函数的地址
    let indirectSymbolBindings = UnsafeMutablePointer<UnsafeMutableRawPointer>(bitPattern: slide+Int(section.pointee.addr))

    guard let _indirectSymbolBindings = indirectSymbolBindings else {
        return
    }
    // 遍历 section 里面的每一个符号
    for i in 0..<Int(section.pointee.size)/MemoryLayout<UnsafeMutableRawPointer>.size {
        //  找到符号在 Indrect Symbol Table 表的值
        //  读取 indirect table 的数据，得到符号在 DATA 段中 section 的位置 （ 适用于懒加载表，和非懒加载表）
        
        let symtabIndex = indirectSymbolIndices.advanced(by: i)
        if symtabIndex.pointee == INDIRECT_SYMBOL_ABS || symtabIndex.pointee == INDIRECT_SYMBOL_LOCAL {
            continue;
        }
        // 以 symtab_index 作为下标，访问 symbol table
        let strtabOffset = symtab.advanced(by: Int(symtabIndex.pointee)).pointee.n_un.n_strx
        // 获取符号名 symbol_name
        let symbolName = strtab.advanced(by: Int(strtabOffset))

        var isEqual = true
        for i in 0..<symbolBytes.count {
            if symbolBytes[i] != symbolName.advanced(by: i+1).pointee {
                //  判断旧方法名，和符号名不一致
                isEqual = false
            }
        }

        if isEqual {
            // 保存的旧函数的实现，有了
            // 这里赋值，成功了
            currentRebinding?.replaced = _indirectSymbolBindings.advanced(by: i).pointee
            // 新函数，交换好了
            _indirectSymbolBindings.advanced(by: i).initialize(to: rebinding.replacement)
        }
    }
}




extension String {
    //Special initializer to get a string from a possibly not-null terminated but usually null-terminated UTF-8 encoded C String.
    init (cString: UnsafeRawPointer!, maxLength: Int) {
        var buffer = [UInt8](repeating: 0, count: maxLength + 1)
        memcpy(&buffer, cString, maxLength)
        self.init(cString: buffer)
    }
}
