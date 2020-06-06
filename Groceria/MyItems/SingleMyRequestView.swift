//
//  SingleMyRequestView.swift
//  Groceria
//
//  Created by Angela Luo on 6/2/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class SingleMyRequestView: UIViewController {

    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameOfRequestLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var numItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var indexPath: IndexPath = IndexPath()
    var delegate: SingleMyRequestViewDelegate?
    
    let db = Firestore.firestore()
    let userID : String = (Auth.auth().currentUser?.uid)!
    
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [], userID: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //create border around table view
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 39, y: 252, width: 339, height: 439)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        view.insertSubview(backgroundView, at: 0)
        
        
        //create drop shadow effect for login button
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowRadius = 2.0
        deleteButton.layer.shadowOpacity = 0.7
        deleteButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        deleteButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        deleteButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        
        nameOfRequestLabel.text = request.nameOfRequest
        nameOfRequestLabel.sizeToFit()
        
        numItemsLabel.text = "Items: \(request.numberOfItems)"
        numItemsLabel.sizeToFit()
        
        var storeName = request.store ?? ""
        if storeName == "" {
            storeName = "None"
        }
        storeLabel.text = "Store: \(storeName)"
        storeLabel.sizeToFit()
        
        
        let docRef = db.collection("dashboardRequests").document("\(request.id)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.data()?["status"] as! String == "completed" {
                    self.deleteButton.isHidden = true
                    let amount = document.data()?["totalAmount"] as! Float
                    let amountLabel = UILabel()
                    amountLabel.frame = self.deleteButton.frame
                    amountLabel.text = "Amount Paid: $\(amount.string(fractionDigits: 2))"
                    amountLabel.sizeToFit()
                    amountLabel.center.x = self.view.center.x
                    self.view.addSubview(amountLabel)
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    
    @IBAction func deleteRequest(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure want to delete this request?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let addAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            //self.delegate?.deleteRequestOnTap(at: self.indexPath)
            //delete from Firebase dashboard requests and from user's myrequests
            print(self.request.id)
            let documentRefString = self.db.collection("dashboardRequests").document("\(self.request.id)")
            
            self.db.collection("users").document(self.userID).updateData( [
                "myUnfulfilledRequests": FieldValue.arrayRemove([documentRefString])
            ]);
            
            self.db.collection("dashboardRequests").document("\(self.request.id)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            
            
            
            
        })
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

protocol SingleMyRequestViewDelegate {
    func deleteRequestOnTap(at index: IndexPath)
}


extension SingleMyRequestView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = request.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem") as! ShoppingItemInactiveCell
        cell.selectionStyle = .none
        cell.setItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = request.items[indexPath.row].extraInfo ?? "None"
        let alert = UIAlertController(title: "Additional Details", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 88 //height of a single list item
//    }

    //called when a cell is selected
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("pressed")
//    }

    //pass data to the next view controller
//    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
//        if (segue.identifier == "goToSingleRequestView") {
//            let viewController = segue.destination as! SingleRequestView
//            viewController.name = cellName
//            viewController.numItems = cellNumItems
//        }
//
//    }
}
