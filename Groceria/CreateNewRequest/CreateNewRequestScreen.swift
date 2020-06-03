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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var shoppingItemTableView: UITableView!
    
    var shoppingItems: [DashboardRequestModel.ShoppingItem] = []
    
    var tabBar: UITabBarController?
    
    var delegate: CreateRequestDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingItemTableView.dataSource = self
        shoppingItemTableView.delegate = self
        
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
        
        //add bottom border for textfield
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        borderLayer.frame = CGRect(x: nameTextField.frame.minX, y: nameTextField.frame.maxY, width: nameTextField.frame.width, height: 1)

        view.layer.addSublayer(borderLayer)
        
        let borderLayer2 = CALayer()
        borderLayer2.backgroundColor = UIColor.gray.cgColor
        borderLayer2.frame = CGRect(x: storeTextField.frame.minX, y: storeTextField.frame.maxY, width: storeTextField.frame.width, height: 1)

        view.layer.addSublayer(borderLayer2)
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
    
    @objc func alertTextFieldDidChange(field: UITextField){
        let alertController:UIAlertController = self.presentedViewController as! UIAlertController;
        let textField: UITextField  = alertController.textFields![0];
        let addAction: UIAlertAction = alertController.actions[1];
        addAction.isEnabled = (textField.text?.count)! > 0;

    }
    
    
    @IBAction func addItemPopup(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name of item"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: UIControl.Event.editingChanged)
        }
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Additional Details"
            
        }
        
        //need to also allow user to upload an image ??
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let addAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { action in
            let firstTextField = alert.textFields![0] as UITextField
            let secondTextField = alert.textFields![1] as UITextField
            var description: String? = secondTextField.text!
            if description == "" {
                description = nil
            }
            let newItem = DashboardRequestModel.ShoppingItem(title: firstTextField.text ?? "No title", extraInfo: description)
            self.shoppingItems.append(newItem)
            let indexPath = IndexPath(row: self.shoppingItems.count - 1, section: 0)
            self.shoppingItemTableView.insertRows(at: [indexPath], with: .automatic)
        })
        
        addAction.isEnabled = false
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitRequest(_ sender: Any) {
        //update dashboard requests
        //update my items
        self.dismiss(animated: true, completion: nil)
        
        var nameRequest = nameTextField.text ?? ""
        if nameRequest == "" {
            nameRequest = "Unnamed"
        }
        var storeName: String? = storeTextField.text ?? ""
        if storeName == "" {
            storeName = nil
        }
        
        let newRequest = DashboardRequestModel(namePerson: "Jane Doe", nameRequest: nameRequest, store: storeName, numberOfItems: shoppingItems.count, items: shoppingItems)
        
        let navController = tabBar!.viewControllers![2] as! UINavigationController
        //let navController = tabBarController?.viewControllers![2] as! UINavigationController
        let vc = navController.topViewController as! InitialMyItemsScreen
        
        vc.hasItems = true
        vc.listOfUnfulfilledRequests.append(newRequest)

        vc.setUpConditionalScreen()
        
        delegate?.addRequestToDashboard(request: newRequest)
        
        
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



extension CreateNewRequestScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = shoppingItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewShoppingItemCell") as! NewShoppingItemCell
        cell.setItem(item: item)
        return cell
    }
    
    //called when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //somehow let user edit here ?
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = shoppingItems[indexPath.row].extraInfo ?? "None"
        let alert = UIAlertController(title: "Additional Details", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        shoppingItems.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
}


protocol CreateRequestDelegate {
    func addRequestToDashboard(request: DashboardRequestModel)
}
