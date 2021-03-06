//
//  FriendsCell.swift
//  Groceria
//
//  Created by Anna Yang on 6/1/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import Foundation
import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    func setFriend(currfriend: FriendsViewModel) {
        nameOfPerson.text = currfriend.nameOfPerson
        nameOfPerson.sizeToFit()
        let imageURL = currfriend.profileImage
        self.profilePicImageView.downloaded(from: imageURL)
    }

}
