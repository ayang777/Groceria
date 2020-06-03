//
//  SingleMyRequestView.swift
//  Groceria
//
//  Created by Angela Luo on 6/2/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class SingleMyRequestView: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameOfRequestLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var numItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //create border around table view
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 39, y: 252, width: 339, height: 439)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        view.insertSubview(backgroundView, at: 0)
        
        
        //create drop shadow effect for login button
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowRadius = 2.0
        editButton.layer.shadowOpacity = 0.7
        editButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        editButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        editButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        
        nameOfRequestLabel.text = request.nameOfRequest
        nameOfRequestLabel.sizeToFit()
        
        numItemsLabel.text = "Items: \(request.numberOfItems)"
        numItemsLabel.sizeToFit()
        
        var storeName = request.store ?? ""
        if storeName == "" {
            storeName = "None"
        }
        storeLabel.text = "Store: \(storeName)"
        storeLabel.sizeToFit()
        
    }
    

}



extension SingleMyRequestView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = request.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem") as! ShoppingItemInactiveCell
        cell.selectionStyle = .none
        cell.setItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = request.items[indexPath.row].extraInfo ?? "None"
        let alert = UIAlertController(title: "Additional Details", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 88 //height of a single list item
//    }

    //called when a cell is selected
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("pressed")
//    }

    //pass data to the next view controller
//    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
//        if (segue.identifier == "goToSingleRequestView") {
//            let viewController = segue.destination as! SingleRequestView
//            viewController.name = cellName
//            viewController.numItems = cellNumItems
//        }
//
//    }
}
