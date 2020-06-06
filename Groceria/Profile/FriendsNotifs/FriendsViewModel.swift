//
//  FriendsViewModel.swift
//  Groceria
//
//  Created by Anna Yang on 6/1/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import Foundation
import UIKit


class FriendsViewModel {
    var nameOfPerson: String
    var emailOfPerson: String
    var profileImage: String
        
    init(name: String, email: String, profileImage: String) {
        self.nameOfPerson = name
        self.emailOfPerson = email
        self.profileImage = profileImage
    }
}
