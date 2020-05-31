//
//  DashboardRequestModel.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import Foundation
import UIKit


class DashboardRequestModel {
    var nameOfPerson: String
    var numberOfItems: Int
    
    init(name: String, numberOfItems: Int) {
        self.nameOfPerson = name
        self.numberOfItems = numberOfItems
    }
}
