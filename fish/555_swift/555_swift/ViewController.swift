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

public func fishhookPrint(newMethod: UnsafeMutableRawPointer) {
    var oldMethod: UnsafeMutableRawPointer?
    rebindSymbol("printf", replacement: newMethod, replaced: &oldMethod)
}

var string = ""



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        fishhookPrint(newMethod: unsafeBitCast(newPrinf as NewPrintf, to: UnsafeMutableRawPointer.self))

        Test.print(withStr: "Hello World \n\n\n")
    }


}

