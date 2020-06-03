//
//  NewShoppingItemCell.swift
//  Groceria
//
//  Created by Angela Luo on 6/2/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class NewShoppingItemCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    
    func setItem(item: DashboardRequestModel.ShoppingItem) {
        itemTitle.text = item.title
        itemTitle.sizeToFit()
    }
    

}
