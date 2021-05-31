//
//  ViewController.swift
//  555_swift
//
//  Created by Jz D on 2021/5/25.
//

import UIKit


typealias NewPrintf = @convention(thin) (String, Any...) -> Void

func newPrinf(str: String, arg: Any...) -> Void {
    print("test success\n\n")
    if let old = oldMethod{
        let thin = unsafeBitCast(
            old, to: NewPrintf.self)
        thin("来来来")
    }
    
    
}


var oldMethod: UnsafeMutableRawPointer?


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        rebindSymbol("NSLog", replacement: unsafeBitCast(newPrinf as NewPrintf, to: UnsafeMutableRawPointer.self), replaced: &oldMethod)

        
        Test.print(withStr: "Hello World \n\n\n")
    }


}

