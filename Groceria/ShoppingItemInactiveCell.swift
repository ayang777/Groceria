//
//  ShoppingItemInactiveCell.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class ShoppingItemInactiveCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    func setItem(item: DashboardRequestModel.ShoppingItem) {
        title.text = item.title
        title.sizeToFit()
    }

}
