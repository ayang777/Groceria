//
//  SettingsScreen.swift
//  Groceria
//
//  Created by Anna Yang on 6/6/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class SettingsScreen: UIViewController, UITextFieldDelegate {
    let db = Firestore.firestore()
    
    // Stored information from firebase
    let userID: String = (Auth.auth().currentUser?.uid)!
    let oldEmail: String = (Auth.auth().currentUser?.email)!
    
    var namePerson: String = ""
    var emailPerson: String = ""
    var address1Person: String = ""
    var address2Person: String = ""
    var cityPerson: String = ""
    var statePerson: String = ""
    var zipPerson: String = ""
    var current: String = ""

    // Name + email popup variables
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityStateTextField: UITextField!
    
    // name popup
    @IBOutlet weak var titleLabelChangePopup: UILabel!
    @IBOutlet var changeProfilePopup: UIView!
    @IBOutlet weak var placeHolderChange: UITextField!
    
    // email popup
    @IBOutlet var changeEmailPopup: UIView!
    @IBOutlet weak var newEmailPlaceholder: UITextField!
    @IBOutlet weak var enterPasswordPlaceholder: UITextField!
    
    // Address popup variables
    @IBOutlet var changeAddressPopup: UIView!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var changeAddressButton: UIButton!
    
    
    // Delete account from system
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: "This action cannot be undone.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            //delete from firebase ?
            do {
                try Auth.auth().signOut()
                //navigationController?.popToRootViewController(animated: true)
                self.performSegue(withIdentifier: "DeleteAccount", sender: nil)
            }
            catch { print("already logged out") }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Change Name, Email, Address popups
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))

    // Change Name
    @IBAction func popNameButton(_ sender: Any) {
        current = "name"
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(changeProfilePopup)
        changeProfilePopup.center = self.view.center
        popupDesign(current: current)
    }

    // Popup email
    @IBAction func popEmailButton(_ sender: Any) {
        current = "email"
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(changeEmailPopup)
        changeEmailPopup.center = self.view.center
        popupDesign(current: current)
        
    }
    
    // Close address popup
    @IBAction func closeAddressPopup(_ sender: Any) {
        self.changeAddressPopup.removeFromSuperview()
        self.blurView.removeFromSuperview()
    }
    
    // Change address popup
    @IBAction func changeAddress(_ sender: Any) {
        // send address information back to firebase
        var newAddress1 = address1TextField.text ?? ""
        var newAddress2 = address2TextField.text ?? ""
        var newCity = cityTextField.text ?? ""
        var newState = stateTextField.text ?? ""
        var newZip = zipTextField.text ?? ""
        
        if newAddress1 == "" {
            newAddress1 = self.address1Person
        }
        if newAddress2 == "" {
            newAddress2 = self.address2Person
        }
        if newCity == "" {
            newCity = self.cityPerson
        }
        if newState == "" {
            newState = self.statePerson
        }
        if newZip == "" {
            newZip = self.zipPerson
        }

            
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {                    self.db.collection("users").document(self.userID).updateData( [
                    "address1": newAddress1
                ]);
                self.db.collection("users").document(self.userID).updateData( [
                    "address2": newAddress2
                ]);
                
                self.db.collection("users").document(self.userID).updateData( [
                    "city": newCity
                ]);
                
                self.db.collection("users").document(self.userID).updateData( [
                    "state": newState
                ]);
                
                self.db.collection("users").document(self.userID).updateData( [
                    "zip": newZip
                    ]);
                self.refreshData()
            } else {
                print("Document does not exist")
            }
        }
        self.changeAddressPopup.removeFromSuperview()
        self.blurView.removeFromSuperview()
    }
    
    // Popup address
    @IBAction func popAddressButton(_ sender: Any) {
        // clear text in placeholders
        self.address1TextField.text = ""
        self.address2TextField.text = ""
        self.cityTextField.text = ""
        self.stateTextField.text = ""
        self.zipTextField.text = ""
        
        current = "address"
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(changeAddressPopup)
        changeAddressPopup.center = self.view.center
        
        self.address1TextField.attributedPlaceholder = NSAttributedString(string: self.address1Person)
        self.address2TextField.attributedPlaceholder = NSAttributedString(string: self.address2Person)
        self.cityTextField.attributedPlaceholder = NSAttributedString(string: self.cityPerson)
        self.stateTextField.attributedPlaceholder = NSAttributedString(string: self.statePerson)
        self.zipTextField.attributedPlaceholder = NSAttributedString(string: self.zipPerson)
    
        changeAddressButton.layer.shadowColor = UIColor.black.cgColor
        changeAddressButton.layer.shadowRadius = 2.0
        changeAddressButton.layer.shadowOpacity = 0.7
        changeAddressButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        changeAddressButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        changeAddressButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
    }
    
    // Close button for name and email
    @IBAction func closeProfilePopup(_ sender: Any) {
        if current == "name" {
            self.changeProfilePopup.removeFromSuperview()
        } else if current == "email" {
            self.changeEmailPopup.removeFromSuperview()
        }
        self.blurView.removeFromSuperview()

    }
    
    // Change button for name and email
    @IBAction func changeButtonPopup(_ sender: Any) {
        if current == "email" {
            let email = newEmailPlaceholder.text ?? ""
            let password = enterPasswordPlaceholder.text ?? ""
            let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
                if let reauthError = error {
                    let alert = UIAlertController(title: "Something went wrong.", message: reauthError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                } else {
                    Auth.auth().currentUser?.updateEmail(to: email) { error in
                        if error != nil {
                            let alert = UIAlertController(title: "Unable to Change Email", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Email updated successfully", message: "", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                                self.db.collection("users").document(self.userID).updateData( [
                                    "email": email
                                ]);
                                self.changeEmailPopup.removeFromSuperview()
                                self.blurView.removeFromSuperview()
                                self.refreshData()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })

        } else {
            //change name in database
            let newName = placeHolderChange.text ?? ""
            if newName == "" {
                let alert = UIAlertController(title: "Error!", message: "Name cannot be empty.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let docRef = db.collection("users").document(userID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {                    self.db.collection("users").document(self.userID).updateData( [
                        "name": newName
                    ]);
                        // self.namePerson = newName
                        self.blurView.removeFromSuperview()
                        self.changeProfilePopup.removeFromSuperview()
                        self.refreshData()
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func refreshData() {
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // grab information and change label placeholders
                self.namePerson = document.data()?["name"] as! String
                self.nameTextField.attributedPlaceholder = NSAttributedString(string: self.namePerson)
                
                self.emailPerson = document.data()?["email"] as! String
                self.emailTextField.attributedPlaceholder = NSAttributedString(string: self.emailPerson)
                
                self.address1Person = document.data()?["address1"] as! String
                self.address2Person = document.data()?["address2"] as! String
                self.cityPerson = document.data()?["city"] as! String
                self.statePerson = document.data()?["state"] as! String
                self.zipPerson = document.data()?["zip"] as! String
                self.cityStateTextField.attributedPlaceholder = NSAttributedString(string: self.cityPerson + ", " + self.statePerson)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Popup for name, email, and address
    func popupDesign (current: String) {
        // clear text in placeholders
        self.placeHolderChange.text = ""
        self.newEmailPlaceholder.text = ""
        self.enterPasswordPlaceholder.text = ""
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        
        if current == "name" {
            self.titleLabelChangePopup.text = "Change Name"
            self.placeHolderChange.attributedPlaceholder = NSAttributedString(string: self.namePerson)
            changeNameButton.layer.shadowColor = UIColor.black.cgColor
            changeNameButton.layer.shadowRadius = 2.0
            changeNameButton.layer.shadowOpacity = 0.7
            changeNameButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            changeNameButton.layer.masksToBounds = false
            changeNameButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        } else if current == "email" {
            self.newEmailPlaceholder.attributedPlaceholder = NSAttributedString(string: "New Email")
            self.enterPasswordPlaceholder.attributedPlaceholder = NSAttributedString(string: "Password")
            changeButton.layer.shadowColor = UIColor.black.cgColor
            changeButton.layer.shadowRadius = 2.0
            changeButton.layer.shadowOpacity = 0.7
            changeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            changeButton.layer.masksToBounds = false
            changeButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        }
        

    }
    
    
    @IBAction func changePasswordButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordScreen") as! ChangePasswordScreen
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull user information
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // grab information and change label placeholders
                self.namePerson = document.data()?["name"] as! String
                self.nameTextField.attributedPlaceholder = NSAttributedString(string: self.namePerson)
                
                self.emailPerson = document.data()?["email"] as! String
                self.emailTextField.attributedPlaceholder = NSAttributedString(string: self.emailPerson)
                
                self.address1Person = document.data()?["address1"] as! String
                self.address2Person = document.data()?["address2"] as! String
                self.cityPerson = document.data()?["city"] as! String
                self.statePerson = document.data()?["state"] as! String
                self.zipPerson = document.data()?["zip"] as! String
                self.cityStateTextField.attributedPlaceholder = NSAttributedString(string: self.cityPerson + ", " + self.statePerson)
            } else {
                print("Document does not exist")
            }
        }
        
                
        // add borders for cells
        nameView.layer.borderWidth = 0.25
        nameView.layer.borderColor = UIColor.lightGray.cgColor
        addressView.layer.borderWidth = 0.25
        addressView.layer.borderColor = UIColor.lightGray.cgColor
        changePasswordView.layer.borderWidth = 0.25
        changePasswordView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.changeAddressPopup.layer.cornerRadius = 8
        self.changeEmailPopup.layer.cornerRadius = 8
        self.changeProfilePopup.layer.cornerRadius = 8

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

