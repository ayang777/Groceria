//
//  FriendsScreenView.swift
//  Groceria
//
//  Created by Anna Yang on 6/1/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import Foundation
import UIKit

class FriendsScreenView: UIViewController {
    var friends: [FriendsViewModel] = []
    var notifs: [FriendsViewModel] = []
    var friendsClicked = true
    var cellName: String = ""
    var cellEmail: String = ""
    var indexPathSelected: IndexPath = IndexPath()
    
    var receivedIndex: IndexPath = IndexPath()
    
    @IBOutlet weak var addFriendView: UIImageView!
    @IBOutlet weak var listOfFriends: UITableView!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var notifsButton: UIButton!
    
    
    @IBAction func friendsTapped(_ sender: Any) {
        friendsClicked = true
        //friends = makeFriends()
        friendsButton.backgroundColor = UIColor.lightGray
        notifsButton.backgroundColor = UIColor.white
        listOfFriends.reloadData()
    }
    
    @IBAction func notifsTapped(_ sender: Any) {
        friendsClicked = false
        // notifs = newFriends()
        notifsButton.backgroundColor = UIColor.lightGray
        friendsButton.backgroundColor = UIColor.white
        listOfFriends.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsButton.backgroundColor = UIColor.lightGray
        
        // Table view of friends and notifs
        listOfFriends.dataSource = self
        listOfFriends.delegate = self
        friends = makeFriends()
        notifs = newFriends()
        
        // Delete friend if needed
//        indexPathSelected = receivedIndex
//        deletedFriend(index: indexPathSelected)
        
        self.addFriendPopup.layer.cornerRadius = 10
        
        print(friends)
        
    }
    
    // Friend popups
    @IBOutlet var addFriendPopup: UIView!
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    
    @IBAction func popButton(_ sender: Any) {
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(addFriendPopup)
        addFriendPopup.center = self.view.center
        //only apply the blur if the user hasn't disabled transparency effects
        //create drop shadow effect for login button
        requestButton.layer.shadowColor = UIColor.black.cgColor
        requestButton.layer.shadowRadius = 2.0
        requestButton.layer.shadowOpacity = 0.7
        requestButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        requestButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        requestButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
    }
    
    @IBAction func closeFriendPopup(_ sender: Any) {
        self.addFriendPopup.removeFromSuperview()
        self.blurView.removeFromSuperview()
    }
    
    @IBAction func requestFriendPopup(_ sender: Any) {
        self.addFriendPopup.removeFromSuperview()
        self.blurView.removeFromSuperview()
    }
    
    
    // Table for Friends
    func makeFriends() -> [FriendsViewModel] {
        var tempFriends: [FriendsViewModel] = []
    
        let request1 = FriendsViewModel(name: "Persis Drell", email: "provost@stanford.edu")
        let request2 = FriendsViewModel(name: "Marc Tessier-Lavigne", email: "marctl@stanford.edu")
        let request3 = FriendsViewModel(name: "Angela Luo", email: "angluo@stanford.edu")
        let request4 = FriendsViewModel(name: "Anna Yang", email: "ayang7@stanford.edu")
      
        tempFriends.append(request1)
        tempFriends.append(request2)
        tempFriends.append(request3)
        tempFriends.append(request4)
        
        return tempFriends
    }
    
    func newFriends() -> [FriendsViewModel] {
        var newFriends: [FriendsViewModel] = []
    
        let request1 = FriendsViewModel(name: "Riva Brubaker-Cole ", email: "stanforddog@stanford.edu")
        let request2 = FriendsViewModel(name: "Susie Brubaker-Cole", email: "vpstudentaffairs@stanford.edu")
        
        newFriends.append(request1)
        newFriends.append(request2)
        
        return newFriends
    }
    
    
    
    // delete friend
//    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
//        print("hi")
//        if segue.identifier == "showSingleFriendViewController" {
//            let singleFriendViewController = segue.destination as! SingleFriendViewController
//            singleFriendViewController.delegate = self
//        }
//    }
//
    func deletedFriend(index: IndexPath) {
        if index != [] {
            friends.remove(at: index.row)
            listOfFriends.deleteRows(at: [index], with: .automatic)
        }
    }
}

// StackOverflow how-to-check-if-indexpath-is-valid
extension UITableView {

    func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

extension FriendsScreenView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsClicked ? friends.count : notifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if friendsClicked {
            let friend = friends[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
            cell.setFriend(currfriend: friend)
            return cell
        } else {
            let notif = notifs[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier:
                "FriendsCell") as! FriendsCell
            cell.setFriend(currfriend:notif)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 88 //height of a single list item
    }
    
    // when cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SingleFriendViewController") as! SingleFriendViewController
        if friendsClicked {
            vc.friend = friends[indexPath.row]
            vc.index = indexPath
            vc.delegate = self
        } else {
            vc.friend = notifs[indexPath.row]
        }
        vc.indexPathSelected = indexPath
        
        // vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension FriendsScreenView: DeleteFriendDelegate {
    func deleteFriend(at index: IndexPath) {
        friends.remove(at: index.row)
        listOfFriends.deleteRows(at: [index], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
}

