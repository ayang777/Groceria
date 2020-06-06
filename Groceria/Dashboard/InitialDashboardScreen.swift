//
//  InitialDashboardScreen.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class InitialDashboardScreen: UIViewController {
    
    var requests: [DashboardRequestModel] = []
    var cellName: String = ""
    var cellNumItems: Int = 0
    var requestItems: [DashboardRequestModel.ShoppingItem] = []
    var request: DashboardRequestModel = DashboardRequestModel(namePerson: "", nameRequest: "", numberOfItems: 0, items: [], userID: "")
    
    let db = Firestore.firestore()
    
    var indexPathSelected: IndexPath = IndexPath()
    
    @IBOutlet weak var listOfRequests: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfRequests.dataSource = self
        listOfRequests.delegate = self
        
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
        
        fetchRequests()
        
//        if let indexPath = listOfRequests.indexPathForSelectedRow {
//            listOfRequests.deselectRow(at: indexPath, animated: true)
//        }
        
        
    }
    
    
    func fetchRequests() {

        //current problem is that the docs are stored alphabetically in Firebase
        
        DispatchQueue.main.async {
            self.db.collection("dashboardRequests")
            .addSnapshotListener { querySnapshot, error in
                self.requests = []
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let requests = documents.map { $0 }
                print(requests.count)
                for request in requests {
                    var itemsToAdd = [DashboardRequestModel.ShoppingItem]()
                    for item in request["items"] as! [[String: Any]] {
                        let shoppingUUID = UUID(uuidString: item["id"] as! String)
                        let shoppingItem = DashboardRequestModel.ShoppingItem(id: shoppingUUID, title: item["title"] as! String, extraInfo: item["extraInfo"] as! String == "" ? nil : item["extraInfo"] as? String, picture: nil)
                        itemsToAdd.append(shoppingItem)
                    }
                    let uuid = UUID(uuidString: request.documentID)
                    let requestToAdd = DashboardRequestModel(id: uuid, namePerson: request["nameOfPerson"] as! String, nameRequest: request["nameOfRequest"] as! String, store: request["storeName"] as! String == "" ? nil : request["storeName"] as? String , numberOfItems: request["numItems"] as! Int, items: itemsToAdd, userID: request["userID"] as! String)
                    if request["status"] as! String == "unfulfilled" {
                         self.requests.append(requestToAdd)
                    }
                    self.listOfRequests.reloadData()
                }

            }
        }
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

//    @IBAction func goToCreateNewRequestScreen(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "CreateRequest", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//    }
}


extension InitialDashboardScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = requests[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardRequestCell") as! DashboardRequestCell
        cell.setRequest(request: request)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 88 //height of a single list item
    }
    
    //called when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellName = requests[indexPath.row].nameOfPerson
        cellNumItems = requests[indexPath.row].numberOfItems
        requestItems = requests[indexPath.row].items
        request = requests[indexPath.row]
        
        indexPathSelected = indexPath
        
        performSegue(withIdentifier: "goToSingleRequestView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //pass data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if (segue.identifier == "goToSingleRequestView") {
            let viewController = segue.destination as! SingleRequestView
            viewController.name = cellName
            viewController.numItems = cellNumItems
            viewController.items = requestItems
            viewController.request = request
            
            viewController.indexPath = indexPathSelected
            viewController.delegate = self
        }
        
        if segue.identifier == "goToCreateRequestFromDashboard" {
            let navController = segue.destination as! UINavigationController
            let firstView = navController.viewControllers.first as! CreateNewRequestScreen
            firstView.tabBar = tabBarController
            firstView.delegate = self
        }
    }
}


extension InitialDashboardScreen: SingleRequestViewDelegate {
    func deleteRequestOnFulfillment(at index: IndexPath) {
        requests.remove(at: index.row)
        listOfRequests.deleteRows(at: [index], with: .automatic)
    }
}


extension InitialDashboardScreen: CreateRequestDelegate {
    func addRequestToDashboard(request: DashboardRequestModel) {
        requests.append(request)
        listOfRequests.insertRows(at: [IndexPath(row: requests.count-1, section: 0)], with: .automatic)
    }
}
