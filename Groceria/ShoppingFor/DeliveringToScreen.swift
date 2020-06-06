//
//  DeliveringToScreen.swift
//  Groceria
//
//  Created by Angela Luo on 6/4/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class DeliveringToScreen: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deliveredButton: UIButton!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    
    let userID : String = (Auth.auth().currentUser?.uid)!
    
    var name: String = ""
    var address1: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    
    let db = Firestore.firestore()
    
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [], userID: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        nameLabel.text = name
        nameLabel.sizeToFit()
        
        //create drop shadow effect for login button
        deliveredButton.layer.shadowColor = UIColor.black.cgColor
        deliveredButton.layer.shadowRadius = 2.0
        deliveredButton.layer.shadowOpacity = 0.7
        deliveredButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        deliveredButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        deliveredButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        addressLine1Label.text = address1
        addressLine1Label.sizeToFit()
        
        addressLine2Label.text = "\(city), \(state) \(zip)"
        addressLine2Label.sizeToFit()
    }
    
    @IBAction func pressedDelivered(_ sender: Any) {
        //remove from shopping for requests
        //update status of request to "delivered"
        
        let documentRefString = db.collection("dashboardRequests").document("\(request.id)")
        db.collection("users").document(userID).updateData( [
            "shoppingForRequests": FieldValue.arrayRemove([documentRefString])
            ], completion: { error in
                self.navigationController?.popToRootViewController(animated: true)
        });
        
        db.collection("dashboardRequests").document("\(self.request.id)").updateData( [
            "status": "delivered",
        ]);
        
        
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
