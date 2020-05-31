//
//  InitialShoppingForScreen.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class InitialShoppingForScreen: UIViewController {
    
    var isShoppingFor: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up header gradient
        let gradient = CAGradientLayer()
        gradient.frame = self.navigationController!.navigationBar.bounds
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        
        if let image = getImageFrom(gradientLayer: gradient) {
            self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
        }

        if isShoppingFor {
            print("hello")
        } else {
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            setUpEmptyScreen()
        }
    }
    
    
    //convert gradient layer to an image to set the top header's background
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    
    func setUpEmptyScreen() {
        //set up background
        self.navigationController?.isNavigationBarHidden = true
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        self.view.layer.insertSublayer(gradient, at:0)
        
        //set up image
        let logo = UIImage(named: "logo.PNG")
        let logoView = UIImageView(image: logo!)
        logoView.frame = CGRect(x: 140, y: 190, width: 140, height: 140)
        self.view.addSubview(logoView)
        
        //set up labels
        let topLabel = UILabel(frame: CGRect(x: 70, y: 351, width: 299, height: 60))
        topLabel.textAlignment = .center
        topLabel.text = "You aren't shopping for\nanyone currently."
        topLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        topLabel.numberOfLines = 2
        topLabel.sizeToFit()
        self.view.addSubview(topLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: 45, y: 430, width: 257, height: 50))
        secondLabel.textAlignment = .center
        
        secondLabel.text = "Check out the Dashboard to find requests!"
        secondLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        secondLabel.sizeToFit()
        self.view.addSubview(secondLabel)
        
        //set up button
        let button = UIButton(frame: CGRect(x: 110, y: 500, width: 205, height: 50))
        button.backgroundColor = .green
        button.setTitle("Go to Dashboard", for: .normal)
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(goToDashboard), for: .touchUpInside)
        
        //create drop shadow effect for login button
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        button.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])

        self.view.addSubview(button)
    }
    
    
    @objc func goToDashboard(sender: UIButton!) {
        tabBarController?.selectedIndex = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
