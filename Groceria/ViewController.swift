//
//  ViewController.swift
//  Groceria
//
//  Created by Angela Luo, Anna Yang.
//  Copyright © 2020 Angela Luo, Anna Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        // gradientLayer.colors = [red:0, green:0.5725490196, blue: 0.2705882353, alpha: 1,).cgColor, UIColor(red: 252/255, green: 238/255, blue: 33/255, alpha: 1).cgColor]
        // top: rgb(157, 115, 195)
        // bottom: rgb(218, 93, 102)
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        // backgroundGradientView.layer.addSublayer(gradient)
        self.view.layer.insertSublayer(gradient, at:0)
    }


}

