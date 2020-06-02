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
    var cellName: String = ""
    var cellEmail: String = ""
    
    @IBOutlet weak var listOfFriends: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfFriends.dataSource = self
        listOfFriends.delegate = self
        
        friends = makeFriends()
    }
    
    
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
    
    
    //convert gradient layer to an image to set the top header's background
//    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
//        var gradientImage:UIImage?
//        UIGraphicsBeginImageContext(gradientLayer.frame.size)
//        if let context = UIGraphicsGetCurrentContext() {
//            gradientLayer.render(in: context)
//            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
//        }
//        UIGraphicsEndImageContext()
//        return gradientImage
//    }

}


extension FriendsScreenView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        cell.setFriend(currfriend: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 88 //height of a single list item
    }
}

