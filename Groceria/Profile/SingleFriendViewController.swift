//
//  SingleFriendViewController.swift
//  Groceria
//
//  Created by Anna Yang on 6/4/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

//protocol DeleteFriendDelegate: AnyObject {
//    func deletedFriend(at index: IndexPath)
//}

class SingleFriendViewController: UIViewController {
    var indexPathSelected: IndexPath = IndexPath()
    var friend: FriendsViewModel = FriendsViewModel(name: "", email: "")

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // weak var delegate: DeleteFriendDelegate? = nil

    // make this weak variable so no strong reference cycle
    // weak var delegate: deleteDelegate? = nil
    
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
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! FriendsScreenView
        secondViewController.receivedIndex = indexPathSelected
        // secondViewController.delegate = self
    }

//    @IBAction func deletedFriend(_ sender: Any) {
//        self.delegate?.deletedFriend(at: indexPathSelected)
//
//        // _ = self.navigationController?.popViewController(animated: true)
//    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if let vc = segue.destination as? FriendsScreenView {
//            vc.currFriend = friend
//        }
//    }
    
}
