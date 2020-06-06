//
//  ShoppingForSingleRequestView.swift
//  Groceria
//
//  Created by Angela Luo on 6/1/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class ShoppingForSingleRequestView: UIViewController {
    
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [], userID: "")
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var uploadReceiptButton: UIButton!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self

        navigationItem.backBarButtonItem?.title = " "
        
        nameLabel.text = request.nameOfPerson
        nameLabel.sizeToFit()
        
        //create border around table view
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 28, y: 241, width: 359, height: 464)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        view.insertSubview(backgroundView, at: 0)
        
        uploadReceiptButton.layer.shadowColor = UIColor.black.cgColor
        uploadReceiptButton.layer.shadowRadius = 2.0
        uploadReceiptButton.layer.shadowOpacity = 0.7
        uploadReceiptButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        uploadReceiptButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        uploadReceiptButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        let docRef = db.collection("dashboardRequests").document("\(request.id)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let status = document.data()?["status"] as! String
                if status == "finished-shopping" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeliveringToScreen") as! DeliveringToScreen
                    vc.name = self.request.nameOfPerson
                    vc.request = self.request
                    let docRef = self.db.collection("users").document(self.request.userID)

                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            if let data = document.data() {
                                vc.address1 = data["address1"] as! String
                                vc.state = data["state"] as! String
                                vc.city = data["city"] as! String
                                vc.zip = data["zip"] as! String
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func alertTextFieldDidChange(field: UITextField){
        let alertController:UIAlertController = self.presentedViewController as! UIAlertController;
        let textField: UITextField  = alertController.textFields![0];
        let addAction: UIAlertAction = alertController.actions[1];
        addAction.isEnabled = (textField.text?.count)! > 0;

    }
    
    @IBAction func finishedShopping(_ sender: Any) {
        let alert = UIAlertController(title: "Thanks for shopping!", message: "Please input the total amount of the purchase.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Amount"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: UIControl.Event.editingChanged)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let addAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeliveringToScreen") as! DeliveringToScreen
            vc.name = self.request.nameOfPerson
            vc.request = self.request
            let docRef = self.db.collection("users").document(self.request.userID)

            let firstTextField = alert.textFields![0] as UITextField
            
            self.db.collection("dashboardRequests").document("\(self.request.id)").updateData( [
                "totalAmount": Float(firstTextField.text ?? "0")!,
                "status": "finished-shopping"
            ]);
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        vc.address1 = data["address1"] as! String
                        vc.state = data["state"] as! String
                        vc.city = data["city"] as! String
                        vc.zip = data["zip"] as! String
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    print("Document does not exist")
                }
            }

            
        })
        
        addAction.isEnabled = false
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
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


extension ShoppingForSingleRequestView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shoppingItem = request.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingForItemCell") as! ShoppingForActiveCell
        cell.setItem(item: shoppingItem)
        return cell
    }
    

    
    //called when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let newCell = cell as! ShoppingForActiveCell
            var item = request.items[indexPath.row]
            item.toggleChecked()
            request.items[indexPath.row] = item
            newCell.setItem(item: request.items[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //called when accessory is clicked
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = request.items[indexPath.row].extraInfo ?? "None"
        let alert = UIAlertController(title: "Additional Details", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //pass data to the next view controller
//    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
//        if (segue.identifier == "goToSingleRequestView") {
//            let viewController = segue.destination as! SingleRequestView
//            viewController.name = cellName
//            viewController.numItems = cellNumItems
//            viewController.items = requestItems
//            viewController.request = request
//        }
//    }
}
