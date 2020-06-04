//
//  DashboardRequestModel.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import Foundation
import UIKit


class DashboardRequestModel: Identifiable, Equatable {
    var id: UUID
    
    static func == (lhs: DashboardRequestModel, rhs: DashboardRequestModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var nameOfPerson: String
    var numberOfItems: Int
    var store: String?
    var nameOfRequest: String
    
    //need to know if visible to public or not
    
    var items: [ShoppingItem]
    
    init(namePerson: String, nameRequest: String, store: String? = nil, numberOfItems: Int, items: [ShoppingItem]) {
        self.id = UUID()
        self.nameOfRequest = nameRequest
        self.nameOfPerson = namePerson
        self.numberOfItems = numberOfItems
        self.items = items
        self.store = store
    }
    
    
    struct ShoppingItem: Identifiable {
        var id: UUID
        var title: String
        var extraInfo: String?
        var picture: UIImage?
        var checked = false
        
        init(title: String, extraInfo: String? = nil, picture: UIImage? = nil) {
            self.id = UUID()
            self.title = title
            self.extraInfo = extraInfo
            self.picture = picture
        }
        
        mutating func toggleChecked() {
            self.checked.toggle()
        }
    }
}
