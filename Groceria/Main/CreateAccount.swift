//
//  CreateAccount.swift
//  Groceria
//
//  Created by Angela Luo on 5/29/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class CreateAccount: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    var email: String = ""
    var password: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        self.view.layer.insertSublayer(gradient, at:0)
        
        
        //create drop shadow effect for Account title
        accountLabel.layer.shadowColor = UIColor.gray.cgColor
        accountLabel.layer.shadowRadius = 3.0
        accountLabel.layer.shadowOpacity = 0.7
        accountLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        accountLabel.layer.masksToBounds = false
        
        //add gesture to next label
        let goToAddressPage = UITapGestureRecognizer(target: self, action: #selector(CreateAccount.goToAddressPage))
        nextLabel.addGestureRecognizer(goToAddressPage)
        
        
        //add gesture to sign in label
        let backToInitialScreen = UITapGestureRecognizer(target: self, action: #selector(CreateAccount.goBackToInitialScreen))
        signInLabel.addGestureRecognizer(backToInitialScreen)
    }
    
    
    @objc func goBackToInitialScreen(gestureRecognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "InitialScreen")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    //might want to make this a navigation controller
    @objc func goToAddressPage(gestureRecognizer: UIGestureRecognizer) {
        if passwordTextField.text?.count == 0 || verifyPasswordTextField.text?.count == 0 || nameTextField.text?.count == 0 || emailTextField.text?.count == 0 {
            let alert = UIAlertController(title: "All fields are required", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if passwordTextField.text ?? "" != verifyPasswordTextField.text ?? "" {
            let alert = UIAlertController(title: "Passwords Do Not Match", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            email = emailTextField.text ?? ""
            name = nameTextField.text ?? ""
            password = passwordTextField.text ?? ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddressSignUp") as! AddressSignUp
            vc.email = email
            vc.name = name
            vc.password = password
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
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
