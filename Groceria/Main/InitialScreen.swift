//
//  ViewController.swift
//  Groceria
//
//  Created by Angela Luo, Anna Yang.
//  Copyright © 2020 Angela Luo, Anna Yang. All rights reserved.
//

import UIKit
import Firebase

class InitialScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var groceriaTitle: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UILabel!
    
    let db = Firestore.firestore()
    
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
        
        //add gesture to sign up button
        let signUpGesture = UITapGestureRecognizer(target: self, action: #selector(InitialScreen.goToCreateAccount))
        signUpButton.addGestureRecognizer(signUpGesture)
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        
        performSegue(withIdentifier: "goToDashboardFromLogin", sender: nil)
    }
    
    @objc func goToCreateAccount(gestureRecognizer: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("textFieldShouldReturn")
//        textField.resignFirstResponder()
//        return true
//    }
//
//    // It is called before text field become active
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.backgroundColor = UIColor.lightGray
//        return true
//    }
//
//    // It is called when text field activated
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textFieldDidBeginEditing")
//    }
//
//    // It is called when text field going to inactive
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        textField.backgroundColor = UIColor.white
//        return true
//    }
//
//    // It is called when text field is inactive
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing")
//    }
//
//    // It is called each time user type a character by keyboard
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(string)
//        return true
//    }


}


extension UIButton {
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

