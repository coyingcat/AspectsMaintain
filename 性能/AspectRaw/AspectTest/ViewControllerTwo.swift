//
//  ViewControllerTwo.swift
//  AspectTest
//
//  Created by Jz D on 2021/5/21.
//

import UIKit

class ViewControllerTwo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.red
        
    }
    

    @objc dynamic func test(id: Int, name: String) {
        print(#function, #file)
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test(id: 6, name: "hah")
    }
}
