//
//  AddressSignUp.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class AddressSignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var goBackLabel: UILabel!
    @IBOutlet weak var address1TextLabel: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var address1: String = ""
    var address2: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    
    var accountCreated = false
    let db = Firestore.firestore()
    
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
        
        if address1TextLabel.text?.count == 0 || cityTextField.text?.count == 0 || stateTextField.text?.count == 0 || zipTextField.text?.count == 0 {
            let alert = UIAlertController(title: "All fields are required", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //CREATE FIREBASE USER HERE
            address1 = address1TextLabel.text ?? ""
            address2 = address2TextField.text ?? ""
            city = cityTextField.text ?? ""
            state = stateTextField.text ?? ""
            zip = zipTextField.text ?? ""
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    if errorCode == AuthErrorCode.invalidEmail {
                        let alert = UIAlertController(title: "Your email address is invalid", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Something went wrong", message: "Please try again", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else if let user = authResult?.user {
                    print(user.uid)
                    self.db.collection("users").document(user.uid).setData([
                        "name": self.name,
                        "email": self.email,
                        "address1": self.address1,
                        "address2": self.address2,
                        "city": self.city,
                        "state": self.state,
                        "zip": self.zip
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(user.uid)")
                        }
                    }
                    self.accountCreated = true
                    self.performSegue(withIdentifier: "goToDashboardFromSignUp", sender: nil)
                }
            }
            
        }
        
    }
    
    @objc func goBackToCreateAccount(gestureRecognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Textfield Delegate
    // When user press the return key in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    // It is called before text field become active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.lightGray
        return true
    }
    
    // It is called when text field activated
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    // It is called when text field going to inactive
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.white
        return true
    }
    
    // It is called when text field is inactive
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    // It is called each time user type a character by keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        return true
    }
    
}
