//
//  SingleNotifViewController.swift
//  Groceria
//
//  Created by Anna Yang on 6/5/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit


class SingleNotifViewController: UIViewController {
    var friend: FriendsViewModel = FriendsViewModel(name: "", email: "")

    var accepted: Bool = true
    var delegate: NotifsDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    @IBAction func acceptNotif(_ sender: Any) {
        accepted = true
        delegate?.checkNotif(accepted: accepted, friend: friend)
    }
    @IBAction func removeNotif(_ sender: Any) {
        accepted = false
        delegate?.checkNotif(accepted: accepted, friend: friend)
    }
    
        
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
}

protocol NotifsDelegate {
    func checkNotif(accepted: Bool, friend: FriendsViewModel)
}
