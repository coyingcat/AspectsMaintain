//
//  ViewController.swift
//  AspectTest
//
//  Created by Jz D on 2021/5/12.
//

import UIKit


import Aspect

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        

        _ = try? hook(selector: #selector(ViewController.test(id:name:)), strategy: .before) { (_, id: Int, name: String) in
            print("ha ha ha")
        }


        
    }
    
    

    @objc dynamic func test(id: Int, name: String) {
        print("come on")
    }
    
    
    
    
    @IBAction func btnClick(_ sender: Any) {
        test(id: 666, name: "click")
    }
    
    
}

