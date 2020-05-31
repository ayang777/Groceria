//
//  DashboardRequestCell.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class DashboardRequestCell: UITableViewCell {

    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    
    func setRequest(request: DashboardRequestModel) {
        nameOfPerson.text = request.nameOfPerson
        numberOfItems.text = "\(request.numberOfItems) items"
    }

}
