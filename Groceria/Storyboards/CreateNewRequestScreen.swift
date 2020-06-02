//
//  CreateNewRequestScreen.swift
//  Groceria
//
//  Created by Angela Luo on 6/2/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class CreateNewRequestScreen: UIViewController {

    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
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
        
        //create drop shadow effect for add item button
        addItemButton.layer.shadowColor = UIColor.black.cgColor
        addItemButton.layer.shadowRadius = 2.0
        addItemButton.layer.shadowOpacity = 0.7
        addItemButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addItemButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        addItemButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        //create drop shadow effect for submit button
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowRadius = 2.0
        submitButton.layer.shadowOpacity = 0.7
        submitButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        submitButton.layer.masksToBounds = false
        
        let buttonColor3 = UIColor(red: 255.0/255.0, green: 181.0/255.0, blue: 186.0/255.0, alpha: 1.0)
        let buttonColor4 = UIColor(red: 218.0/255.0, green: 93.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        submitButton.applyGradient(colors: [buttonColor3.cgColor, buttonColor4.cgColor])
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
    

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
