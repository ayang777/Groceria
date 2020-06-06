//
//  YourShopperIsScreen.swift
//  Groceria
//
//  Created by Angela Luo on 6/3/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class YourShopperIsScreen: UIViewController {
    
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [], userID: "")
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shopperNameLabel: UILabel!
    @IBOutlet weak var markDeliveredButton: UIButton!
    @IBOutlet weak var yourTotalLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yourTotalLabel.text = ""
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //create border around table view
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 35, y: 213, width: 344, height: 415)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        view.insertSubview(backgroundView, at: 0)

        if let shopper = request.shopperID {
            let docRef = db.collection("users").document(shopper)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.shopperNameLabel.text = document.data()?["name"] as? String
                    self.shopperNameLabel.sizeToFit()
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        let docRef = db.collection("dashboardRequests").document("\(request.id)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.data()?["status"] as! String == "finished-shopping" || document.data()?["status"] as! String == "delivered" {
                    let amount = document.data()?["totalAmount"] as! Float
                    self.yourTotalLabel.text = "Your total is $\(amount.string(fractionDigits: 2))"
                    self.yourTotalLabel.sizeToFit()
                    self.yourTotalLabel.center.x = self.view.center.x
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
        //create drop shadow effect for login button
        markDeliveredButton.layer.shadowColor = UIColor.black.cgColor
        markDeliveredButton.layer.shadowRadius = 2.0
        markDeliveredButton.layer.shadowOpacity = 0.7
        markDeliveredButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        markDeliveredButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        markDeliveredButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
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


extension YourShopperIsScreen: UITableViewDataSource, UITableViewDelegate {
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


extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
