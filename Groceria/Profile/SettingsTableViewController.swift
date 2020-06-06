//
//  SettingsTableViewController.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.isScrollEnabled = false
    }
    
    //called when a cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingsScreen") as! SettingsScreen
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FriendsScreenView") as! FriendsScreenView
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FulfilledRequestsScreen") as! FulfilledRequestsScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
