//
//  ViewController.swift
//  555_swift
//
//  Created by Jz D on 2021/5/25.
//

import UIKit


typealias NewPrintf = @convention(thin) (String, Any...) -> Void

func newPrinf(str: String, arg: Any...) -> Void {
    string = "test success"
    print(string + "\n\n")
}



var string = ""



class ViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var oldMethod: UnsafeMutableRawPointer?
        rebindSymbol("printf", replacement: unsafeBitCast(newPrinf as NewPrintf, to: UnsafeMutableRawPointer.self), replaced: &oldMethod)
        Test.print(withStr: "Hello World \n\n\n")
        print(oldMethod == nil)
    }


}

