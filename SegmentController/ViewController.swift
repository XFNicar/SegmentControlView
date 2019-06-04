//
//  ViewController.swift
//  SegmentController
//
//  Created by YanYi on 2019/6/4.
//  Copyright © 2019 YanYi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.present(SegmentViewController(), animated: true) {
            
        }
    }

}

