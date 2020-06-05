//
//  SingleRequestView.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class SingleRequestView: UIViewController {

    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var fulfillButton: UIButton!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    let db = Firestore.firestore()
    let userID : String = (Auth.auth().currentUser?.uid)!
    
    var name: String = ""
    var numItems: Int = 0
    var items: [DashboardRequestModel.ShoppingItem] = []
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [], userID: "")
    
    var indexPath: IndexPath = IndexPath()
    var delegate: SingleRequestViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self

        //setting up header gradient
        let gradient = CAGradientLayer()
        gradient.frame = self.navigationController!.navigationBar.bounds
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        
        if let image = getImageFrom(gradientLayer: gradient) {
            self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
        
        //create border around table view
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 39, y: 252, width: 339, height: 439)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        view.insertSubview(backgroundView, at: 0)
        
        
        //create drop shadow effect for login button
        fulfillButton.layer.shadowColor = UIColor.black.cgColor
        fulfillButton.layer.shadowRadius = 2.0
        fulfillButton.layer.shadowOpacity = 0.7
        fulfillButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        fulfillButton.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        fulfillButton.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])
        
        
        nameOfPerson.text = name
        nameOfPerson.sizeToFit()
        
        numberOfItems.text = "Items: \(numItems)"
        numberOfItems.sizeToFit()
        
        var store = request.store ?? ""
        if store == "" {
            store = "None"
        }
        storeName.text = "Store: \(store)"
        storeName.sizeToFit()
    }
    
    //convert gradient layer to an image to set the top header's background
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    
    @IBAction func fulfillRequest(_ sender: Any) {
        //add to user's shopping for array
        //remove from request dashboard - should it be removed from the database entirely or just the dashboard UI ?
        //remove from other user's myunfulfilled request
        //add to other user's inprogress request
        //change the request's status to in progress
        
        
        let documentRefString = db.collection("dashboardRequests").document("\(request.id)")
        db.collection("users").document(userID).updateData( [
            "shoppingForRequests": FieldValue.arrayUnion([documentRefString])
        ]);
        
        
//        self.db.collection("dashboardRequests").document("\(self.request.id)").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//                _ = self.navigationController?.popViewController(animated: true)
//            }
//        }
        
        
        let navController = tabBarController?.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! InitialShoppingForScreen
        
        vc.isShoppingFor = true
        vc.listOfRequests.append(request)
        vc.setUpConditionalScreen()
        
        //self.delegate?.deleteRequestOnFulfillment(at: indexPath)
        
        
        tabBarController?.selectedIndex = 1
    }
    
    
}


protocol SingleRequestViewDelegate {
    func deleteRequestOnFulfillment(at index: IndexPath)
}


extension SingleRequestView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem") as! ShoppingItemInactiveCell
        cell.selectionStyle = .none
        cell.setItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = items[indexPath.row].extraInfo ?? "None"
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
