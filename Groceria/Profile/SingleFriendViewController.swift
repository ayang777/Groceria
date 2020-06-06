//
//  SingleFriendViewController.swift
//  Groceria
//
//  Created by Anna Yang on 6/4/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit


class SingleFriendViewController: UIViewController {
    var indexPathSelected: IndexPath = IndexPath()
    var friend: FriendsViewModel = FriendsViewModel(name: "", email: "")

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    var index: IndexPath = IndexPath()
    var delegate: DeleteFriendDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameLabel.text = friend.nameOfPerson
        nameLabel.sizeToFit()
        // nameLabel.center.x = self.view.center.x
        
        emailLabel.text = friend.emailOfPerson
        emailLabel.sizeToFit()
        // emailLabel.center.x = self.view.center.x
    
    }
    
    @IBOutlet weak var deletedFriend: UIButton!

    @IBAction func deleteFriend(_ sender: Any) {
        delegate?.deleteFriend(at: index, friend: friend)
        
    }
    
}

protocol DeleteFriendDelegate {
    func deleteFriend(at index: IndexPath, friend: FriendsViewModel)
}
