//
//  DashboardRequestCell.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class DashboardRequestCell: UITableViewCell {

    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    let db = Firestore.firestore()
    
    func setRequest(request: DashboardRequestModel) {
        nameOfPerson.text = request.nameOfPerson
        numberOfItems.text = "\(request.numberOfItems) items"
        
        let docRef = db.collection("users").document(request.userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userProfilePic.downloaded(from: document.data()?["profileImage"] as! String)
            } else {
                print("Document does not exist")
            }
        }
    }

}
