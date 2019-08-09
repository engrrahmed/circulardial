//
//  ViewController.swift
//  TemperatureDial
//
//  Created by Rizwan Ahmed on 07/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let circularView = Bundle.main.loadNibNamed("CircularView", owner: self, options: nil)?[0] as? CircularView {
            circularView.setNeedsLayout()
            let width = view.bounds.size.width - 30
            let height = view.bounds.size.height - width / 4
            
            circularView.frame = CGRect(x: 15, y: width / 4, width: width, height: width)
            circularView.backgroundColor  = .yellow
             self.view.addSubview(circularView)
        }
//        let circularView = RectangleView(frame: CGRect(x: -100, y: -12, width: 100, height: 24))
//          self.view.addSubview(circularView)
    }

}

