//
//  ViewController.swift
//  AspectTest
//
//  Created by Jz D on 2021/5/12.
//

import UIKit


import Aspect

var cnt = 1

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
            _ = try? hook(selector: #selector(ViewController.test(id:name:)), strategy: .before) { (_, id: Int, name: String) in
                print("ViewController.test(id:name:))")
            
        }
    }
    
    

    @objc dynamic func test(id: Int, name: String) {
        print(#function,  #file)
        let ctrl = ViewControllerTwo()
        present(ctrl, animated: true) {
        }
        if cnt == 1{
            _ = try? ctrl.hook(selector: #selector(ViewControllerTwo.viewWillAppear(_:)), strategy: .before){ (_, ok: Bool) in
                print("ViewControllerTwo.viewWillAppear(_:)")
            }
            
            
            _ = try? ctrl.hook(selector: #selector(ViewControllerTwo.test(id:name:)), strategy: .before){ (_, id: Int, name: String) in
                print("ViewControllerTwo.test(id:name:) ")
            }
            cnt = 2
        }
        
    }
    
    
    
    
    @IBAction func btnClick(_ sender: Any) {
        test(id: 666, name: "click")
    }
    
    
}

