//
//  ViewController.swift
//  Groceria
//
//  Created by Angela Luo, Anna Yang.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class InitialScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var groceriaTitle: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // FORGOT PASSWORD
    @IBOutlet var forgotPasswordPopup: UIView!
    @IBOutlet weak var userTypedEmail: UITextField!
    @IBOutlet weak var requestPassword: UIButton!
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    @IBAction func forgotPassword(_ sender: Any) {
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(forgotPasswordPopup)
        forgotPasswordPopup.center = self.view.center
        forgotPasswordPopup.layer.cornerRadius = 5
        requestPassword.layer.shadowColor = UIColor.darkGray.cgColor
        requestPassword.layer.shadowRadius = 2.0
        requestPassword.layer.shadowOpacity = 0.7
        requestPassword.layer.shadowOffset = CGSize(width: 2, height: 2)
        requestPassword.layer.masksToBounds = false
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        requestPassword.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
    }
    
    // clicked request password
    @IBAction func clickedRequest(_ sender: Any) {
        let email = userTypedEmail.text ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            //Make sure you execute the following code on the main queue
            DispatchQueue.main.async {
                //Use "if let" to access the error, if it is non-nil
                if let error = error {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                } else {
                    // if email in database:
                    self.forgotPasswordPopup.removeFromSuperview()
                    self.blurView.removeFromSuperview()
                    let alert = UIAlertController(title: "New password requested", message: "Please check your email for further information.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func cancelResetPassword(_ sender: Any) {
        self.forgotPasswordPopup.removeFromSuperview()
        self.blurView.removeFromSuperview()
    }
    
    
    
    var email: String = ""
    var password: String = ""
    
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
        
        self.forgotPasswordPopup.layer.cornerRadius = 8 
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
        //perform firebase auth
        
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                if errorCode == AuthErrorCode.wrongPassword {
                    let alert = UIAlertController(title: "Your password is incorrect", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Unable to Login", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            } else if let _ = authResult?.user {
                self?.performSegue(withIdentifier: "goToDashboardFromLogin", sender: nil)
            }
        }
        
        
    }
    
    @objc func goToCreateAccount(gestureRecognizer: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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

