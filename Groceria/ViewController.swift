//
//  ViewController.swift
//  Groceria
//
//  Created by Angela Luo, Anna Yang.
//  Copyright © 2020 Angela Luo, Anna Yang. All rights reserved.
//

import UIKit

class InitialScreen: UIViewController {
    
    @IBOutlet weak var groceriaTitle: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
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
        
        
        //create drop shadow effect for Groceria title
        groceriaTitle.layer.shadowColor = UIColor.gray.cgColor
        groceriaTitle.layer.shadowRadius = 3.0
        groceriaTitle.layer.shadowOpacity = 0.7
        groceriaTitle.layer.shadowOffset = CGSize(width: 3, height: 3)
        groceriaTitle.layer.masksToBounds = false
        
        //create drop shadow effect for login button
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowRadius = 2.0
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        loginButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
    }


}


extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

