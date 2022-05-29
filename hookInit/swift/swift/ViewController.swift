//
//  ViewController.swift
//  swift
//
//  Created by Jz D on 2022/5/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let v_v = UICollectionView(frame: CGRect(x: 50, y: 50, width: 120, height: 120), collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(v_v)
        
    }


}

