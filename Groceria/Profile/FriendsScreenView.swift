//
//  FriendsScreenView.swift
//  Groceria
//
//  Created by Anna Yang on 6/1/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Note: currently cannot add friend when in notifications tab (it breaks)
class FriendsScreenView: UIViewController {
    let db = Firestore.firestore()
    
    let userID: String = (Auth.auth().currentUser?.uid)!
    var namePerson: String = ""
    
    var friends: [FriendsViewModel] = []
    var notifs: [FriendsViewModel] = []
    var friendsClicked = true
    var cellName: String = ""
    var cellEmail: String = ""
    var indexPathSelected: IndexPath = IndexPath()
    var friend: FriendsViewModel = FriendsViewModel(name: "", email: "", profileImage: "")
    
    var receivedIndex: IndexPath = IndexPath()
    
    @IBOutlet weak var addFriendView: UIImageView!
    @IBOutlet weak var listOfFriends: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var notifsButton: UIButton!
    
    
    @IBAction func friendsTapped(_ sender: Any) {
        self.friends.removeAll()
        friendsClicked = true
        friendsButton.backgroundColor = UIColor.lightGray
        notifsButton.backgroundColor = UIColor.white
        fetchFriends()
        listOfFriends.reloadData()
    }
    
    @IBAction func notifsTapped(_ sender: Any) {
        self.notifs.removeAll()
        friendsClicked = false
        notifsButton.backgroundColor = UIColor.lightGray
        friendsButton.backgroundColor = UIColor.white
        fetchFriends()
        listOfFriends.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.namePerson = document.data()?["name"] as! String
            } else {
                print("Document does not exist")
            }
        }
        
        friendsButton.backgroundColor = UIColor.lightGray
        
        // Table view of friends and notifs
        listOfFriends.dataSource = self
        listOfFriends.delegate = self
        
        self.addFriendPopup.layer.cornerRadius = 10
        fetchFriends()
    }

    
    // Add friend popups
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
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
        // Add friend
        if nameField.text?.isEmpty == false && emailField.text?.isEmpty == false {
            let email = emailField.text!
            
            // TODO: check if email exists in database
            let userRef = db.collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // No documents were found matching email (ie user doesn't exist)
                    if querySnapshot!.documents == [] {
                        self.addFriendPopup.removeFromSuperview()
                        self.blurView.removeFromSuperview()
                        let alert = UIAlertController(title: "Sorry!", message: "This account does not exist.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else { // matching user found to add
                        for document in querySnapshot!.documents  {
                            // add friend's ID into user's sent requests
                            let friendRefString = "\(document.documentID)"
                            self.db.collection("users").document(self.userID).updateData( [
                                "sentFriendRequests": FieldValue.arrayUnion([friendRefString])
                            ]);
                            // add user's ID into notifications
                            let userRefString = "\(self.userID)"
                            self.db.collection("users").document(document.documentID).updateData([
                                "notifications": FieldValue.arrayUnion([userRefString])
                            ]);
                        }
                        // clear and reload table
                        self.friends.removeAll()
                        self.notifs.removeAll()
                        self.fetchFriends()
                        
                        // deal with views
                        self.addFriendPopup.removeFromSuperview()
                        self.blurView.removeFromSuperview()
                    }
                }
            }
        } else {
            
            self.addFriendPopup.removeFromSuperview()
            self.blurView.removeFromSuperview()
            let alert = UIAlertController(title: "Sorry! We could not find that account.", message: "Please enter a valid name and email.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        emailField.text = ""
        nameField.text = ""
    }
    
    
    func fetchFriends() {
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if self.friendsClicked == true { // DISPLAY FRIENDS
                    let currfriends = document["currFriends"] as? Array ?? []
                    for c_friend in currfriends {
                        let friendRef = self.db.collection("users").document(c_friend as! String) // find using friend ID
                        friendRef.getDocument { (doc, err) in
                            if let doc = doc, doc.exists {
                                let friendName = doc["name"] as? String ?? ""
                                let friendEmail = doc["email"] as? String ?? ""
                                let friendProfileImage = doc["profileImage"] as? String ?? ""
                                let friendToView = FriendsViewModel(name: friendName, email: friendEmail, profileImage: friendProfileImage)
                                self.friends.append(friendToView)
                                self.listOfFriends.reloadData()
                            }
                        }
                    }
                } else { // DISPLAY NOTIFS
                    let currnotifs = document["notifications"] as? Array ?? []
                    for c_notif in currnotifs {
                        let notifRef = self.db.collection("users").document(c_notif as! String) // find using notif ID
                        notifRef.getDocument { (doc, err) in
                            if let doc = doc, doc.exists {
                                let notifName = doc["name"] as? String ?? ""
                                let notifEmail = doc["email"] as? String ?? ""
                                let notifProfileImage = doc["profileImage"] as? String ?? ""
                                let notifToView = FriendsViewModel(name: notifName, email: notifEmail, profileImage: notifProfileImage)
                                self.notifs.append(notifToView)
                                self.listOfFriends.reloadData()
                            }
                        }
                    }
                }
                
            } else {
                print("Document does not exist ")
            }
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
        if friendsClicked {
            let vc = storyboard.instantiateViewController(withIdentifier: "SingleFriendViewController") as! SingleFriendViewController
            vc.friend = friends[indexPath.row]
            vc.index = indexPath
            vc.delegate = self
            vc.indexPathSelected = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        } else { // notifs
            let vc = storyboard.instantiateViewController(withIdentifier: "SingleNotifViewController") as! SingleNotifViewController
            vc.friend = notifs[indexPath.row]
            vc.accepted = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        // vc.indexPathSelected = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension FriendsScreenView: DeleteFriendDelegate {
    func deleteFriend(at index: IndexPath, friend: FriendsViewModel) {
        let deleteEmail = friend.emailOfPerson
        friends.remove(at: index.row)
        listOfFriends.deleteRows(at: [index], with: .automatic)
        
        let userRef = db.collection("users").document(userID)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var currfriends = document["currFriends"] as? Array ?? [""] // list of friend ID's
                for c_friend in currfriends { // check name for ID, if it matches -- delete (also need to delete for friend)
                    let c_friendRef = self.db.collection("users").document(c_friend as String)
                    c_friendRef.getDocument { (friendDoc, friendError) in
                        if let friendDoc = friendDoc, friendDoc.exists {
                            // Find matching friend email
                            if (friendDoc["email"] as? String ?? "") == deleteEmail {
                                // REMOVE FRIEND FOR USER
                                let index = currfriends.firstIndex(of: c_friend)
                                currfriends.remove(at: index!)
                            self.db.collection("users").document(self.userID).updateData( [
                                    "currFriends": currfriends
                                ]);
                                
                                // REMOVE USER FOR FRIEND
//                                var friends_currfriends = friendDoc["currFriends"] as? Array ?? [""]
//                                
//                                let user_index = friends_currfriends.firstIndex(of: self.userID)
//                                friends_currfriends.remove(at: user_index!)
//                                
//                                self.db.collection("users").document(c_friend).updateData(["currFriends": friends_currfriends]);
                                
                                // remove user ID from friends list of currFriends
                                // clear and reload table
                                self.friends.removeAll()
                                self.fetchFriends()
                            }
                        } else {
                            print("Friend does not exist")
                        }
                    }
                }
            } else {
                print("Document does not exist ")
            }
        }
            
        navigationController?.popViewController(animated: true)
    }
}

extension FriendsScreenView: NotifsDelegate {
    func checkNotif(accepted: Bool, friend: FriendsViewModel) {
        print(accepted)
        print(friend.nameOfPerson)
        // both: remove from notifs
        // if true: add to friends table
        navigationController?.popViewController(animated: true)
    }
}




// DELETED CODE
// Original Hard-coded Table for Friends
//    func makeFriends() -> [FriendsViewModel] {
//        var tempFriends: [FriendsViewModel] = []
//
//        let request1 = FriendsViewModel(name: "Persis Drell", email: "provost@stanford.edu")
//        let request2 = FriendsViewModel(name: "Marc Tessier-Lavigne", email: "marctl@stanford.edu")
//        let request3 = FriendsViewModel(name: "Angela Luo", email: "angluo@stanford.edu")
//        let request4 = FriendsViewModel(name: "Anna Yang", email: "ayang7@stanford.edu")
//
//        tempFriends.append(request1)
//        tempFriends.append(request2)
//        tempFriends.append(request3)
//        tempFriends.append(request4)
//
//        return tempFriends
//    }
//
//    func newFriends() -> [FriendsViewModel] {
//        var newFriends: [FriendsViewModel] = []
//
//        let request1 = FriendsViewModel(name: "Riva Brubaker-Cole ", email: "stanforddog@stanford.edu")
//        let request2 = FriendsViewModel(name: "Susie Brubaker-Cole", email: "vpstudentaffairs@stanford.edu")
//
//        newFriends.append(request1)
//        newFriends.append(request2)
//
//        return newFriends
//    }
    

    // DELETE FRIEND
//    func deletedFriend(index: IndexPath, friend: FriendsViewModel) {
//        if index != [] {
//            friends.remove(at: index.row)
//            listOfFriends.deleteRows(at: [index], with: .automatic)
//        }
//    }
