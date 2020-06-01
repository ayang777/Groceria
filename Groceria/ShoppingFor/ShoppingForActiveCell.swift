//
//  ShoppingForActiveCell.swift
//  Groceria
//
//  Created by Angela Luo on 6/1/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class ShoppingForActiveCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    var isChecked: Bool = false
    
    func setItem(item: DashboardRequestModel.ShoppingItem) {
        title.text = item.title
        title.sizeToFit()
        isChecked = item.checked
        if isChecked {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
        }
   }

}
