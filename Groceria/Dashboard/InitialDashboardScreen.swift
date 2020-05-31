//
//  InitialDashboardScreen.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit

class InitialDashboardScreen: UIViewController {
    
    var requests: [DashboardRequestModel] = []
    var cellName: String = ""
    var cellNumItems: Int = 0
    var requestItems: [DashboardRequestModel.ShoppingItem] = []
    
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
        
        requests = createRequests()
        
//        if let indexPath = listOfRequests.indexPathForSelectedRow {
//            listOfRequests.deselectRow(at: indexPath, animated: true)
//        }
        
        
    }
    
    
    func createRequests() -> [DashboardRequestModel] {
        var tempRequests: [DashboardRequestModel] = []
        
        let sampleItems1 = [DashboardRequestModel.ShoppingItem(title: "Eggs"), DashboardRequestModel.ShoppingItem(title: "Bread"), DashboardRequestModel.ShoppingItem(title: "Milk"), DashboardRequestModel.ShoppingItem(title: "Water")]
        
        let sampleItems2 = [DashboardRequestModel.ShoppingItem(title: "Carrots"), DashboardRequestModel.ShoppingItem(title: "Squash")]
        
        let sampleItems3 = [DashboardRequestModel.ShoppingItem(title: "Granola Bars")]
        
        let sampleItems4 = [DashboardRequestModel.ShoppingItem(title: "Orange Juice"), DashboardRequestModel.ShoppingItem(title: "Twinkies"), DashboardRequestModel.ShoppingItem(title: "Sandies"), DashboardRequestModel.ShoppingItem(title: "Gushers")]
        
        let sampleItems5 = [DashboardRequestModel.ShoppingItem(title: "Oreos"), DashboardRequestModel.ShoppingItem(title: "Milk")]
        
        let request1 = DashboardRequestModel(name: "Jane Doe", numberOfItems: 4, items: sampleItems1)
        let request2 = DashboardRequestModel(name: "Jim Smith", numberOfItems: 2, items: sampleItems2)
        let request3 = DashboardRequestModel(name: "Angela Luo", numberOfItems: 10, items: [])
        let request4 = DashboardRequestModel(name: "Anna Yang", numberOfItems: 7, items: [])
        let request5 = DashboardRequestModel(name: "Michael Smith", numberOfItems: 1, items: sampleItems3)
        let request6 = DashboardRequestModel(name: "Jimmy Neutron", numberOfItems: 11, items: [])
        let request7 = DashboardRequestModel(name: "Timmy Turner", numberOfItems: 5, items: [])
        let request8 = DashboardRequestModel(name: "Persis Drell", numberOfItems: 4, items: sampleItems4)
        let request9 = DashboardRequestModel(name: "Ariana Grande", numberOfItems: 2, items: sampleItems5)
        
        
        tempRequests.append(request1)
        tempRequests.append(request2)
        tempRequests.append(request3)
        tempRequests.append(request4)
        tempRequests.append(request5)
        tempRequests.append(request6)
        tempRequests.append(request7)
        tempRequests.append(request8)
        tempRequests.append(request9)
        
        return tempRequests
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
        }
    }
}
