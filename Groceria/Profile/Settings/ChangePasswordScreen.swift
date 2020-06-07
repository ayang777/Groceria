//
//  ChangePasswordScreen.swift
//  Groceria
//
//  Created by Anna Yang on 6/6/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordScreen: UIViewController {
    
    let db = Firestore.firestore()
    
    // Stored information from firebase
    let userID: String = (Auth.auth().currentUser?.uid)!
    let email: String = (Auth.auth().currentUser?.email)!

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var verifyNewPasswordTextField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    @IBAction func changePasswordButton(_ sender: Any) {
        let oldPassword = oldPasswordTextField.text ?? ""
        let newPassword = newPasswordTextField.text ?? ""
        let verifyPassword = verifyNewPasswordTextField.text ?? ""
        
        if newPassword != verifyPassword {
            let alert = UIAlertController(title: "Error!", message: "Your passwords did not match each other.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
            if let reauthError = error {
                let alert = UIAlertController(title: "Something went wrong.", message: reauthError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            } else {
                Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                    if error != nil {
                        let alert = UIAlertController(title: "Unable to Change Password", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // Change storyboard back
                        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsScreen") as! SettingsScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                        let alert = UIAlertController(title: "Password Changed!", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeButton.layer.shadowColor = UIColor.black.cgColor
        changeButton.layer.shadowRadius = 2.0
        changeButton.layer.shadowOpacity = 0.7
        changeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        changeButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        changeButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
    }

}
