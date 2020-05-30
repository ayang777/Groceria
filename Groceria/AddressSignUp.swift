//
//  AddressSignUp.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class AddressSignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var goBackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        self.view.layer.insertSublayer(gradient, at:0)
        
        //create drop shadow effect for Address title
        addressLabel.layer.shadowColor = UIColor.gray.cgColor
        addressLabel.layer.shadowRadius = 3.0
        addressLabel.layer.shadowOpacity = 0.7
        addressLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        addressLabel.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        signUpButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        //add gesture to next label
        let goBackToCreateAccount = UITapGestureRecognizer(target: self, action: #selector(AddressSignUp.goBackToCreateAccount))
        goBackLabel.addGestureRecognizer(goBackToCreateAccount)
    }
    

    @IBAction func goToDashboard(_ sender: Any) {
        performSegue(withIdentifier: "goToDashboardFromSignUp", sender: nil)
    }
    
    @objc func goBackToCreateAccount(gestureRecognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
