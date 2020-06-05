//
//  InitialMyItemsScreen.swift
//  Groceria
//
//  Created by Angela Luo on 5/31/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class InitialMyItemsScreen: UIViewController {
    
    @Published var hasItems: Bool = true
    
    var listOfUnfulfilledRequests: [DashboardRequestModel] = []
    
    var listOfRequestsInProgress: [DashboardRequestModel] = []
    
    var isInProgressClicked = false
    let db = Firestore.firestore()
    let userID : String = (Auth.auth().currentUser?.uid)!
    
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConditionalScreen()
        fetchMyRequestsFromFirebase()
        listOfRequestsInProgress = createFakeRequests()
        
        if listOfRequestsInProgress.count == 0 && listOfUnfulfilledRequests.count == 0 {
            hasItems = false
        } else {
            hasItems = true
        }
    }
    
    
    func createFakeRequests() -> [DashboardRequestModel] {
        var tempRequests: [DashboardRequestModel] = []
        
//        let sampleItems1 = [DashboardRequestModel.ShoppingItem(title: "Eggs", extraInfo: "one dozen, triple A eggs"), DashboardRequestModel.ShoppingItem(title: "Bread"), DashboardRequestModel.ShoppingItem(title: "Milk", extraInfo: "2 percent"), DashboardRequestModel.ShoppingItem(title: "Water")]
//
//        let sampleItems2 = [DashboardRequestModel.ShoppingItem(title: "Carrots"), DashboardRequestModel.ShoppingItem(title: "Squash")]
//
//        let sampleItems3 = [DashboardRequestModel.ShoppingItem(title: "Granola Bars")]
//
//        let request1 = DashboardRequestModel(namePerson: "Jane Doe", nameRequest: "Quick Run", store: "Safeway", numberOfItems: 4, items: sampleItems1)
//        let request2 = DashboardRequestModel(namePerson: "Jane Doe", nameRequest: "Unnamed", numberOfItems: 2, items: sampleItems2)
//        let request3 = DashboardRequestModel(namePerson: "Jane Doe", nameRequest: "Cheap Eats", store: "Walmart", numberOfItems: 1, items:sampleItems3)
//
//        tempRequests.append(request1)
//        tempRequests.append(request2)
//        tempRequests.append(request3)

        return tempRequests
    }

    
    override func viewWillAppear(_ animated: Bool) {
        setUpConditionalScreen()
    }
    
    func setUpConditionalScreen() {
        clearScreen()
        if hasItems {
            self.navigationController?.isNavigationBarHidden = false
            
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
            
            let myItemsLabel = UILabel(frame: CGRect(x: 141, y: 123, width: 132, height: 36))
            myItemsLabel.textAlignment = .center
            myItemsLabel.text = "My Items"
            myItemsLabel.textColor = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:1.0)
            myItemsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
            myItemsLabel.sizeToFit()
            self.view.addSubview(myItemsLabel)
            
            let button1 = UIButton(frame: CGRect(x: 56, y: 167, width: 151, height: 30))
            button1.layer.borderWidth = 1
            button1.layer.borderColor = UIColor.black.cgColor
            button1.setTitle("Unfulfilled", for: .normal)
            button1.setTitleColor(UIColor.black, for: .normal)
            button1.backgroundColor = !isInProgressClicked ? UIColor.lightGray : UIColor.white
            button1.addTarget(self, action: #selector(unfulfilledPressed), for: .touchUpInside)

            self.view.addSubview(button1)
            
            
            let button2 = UIButton(frame: CGRect(x: 207, y: 167, width: 151, height: 30))
            button2.layer.borderWidth = 1
            button2.layer.borderColor = UIColor.black.cgColor
            button2.setTitle("In Progress", for: .normal)
            button2.setTitleColor(UIColor.black, for: .normal)
            button2.backgroundColor = isInProgressClicked ? UIColor.lightGray : UIColor.white
            button2.addTarget(self, action: #selector(inProgressPressed), for: .touchUpInside)

            self.view.addSubview(button2)
            createCollectionView()
            
        } else {
            setUpEmptyScreen()
        }
    }
    
    @objc func inProgressPressed(sender: UIButton!) {
        self.isInProgressClicked = true
        setUpConditionalScreen()
        //collectionView?.reloadData()
        
    }
    
    
    @objc func unfulfilledPressed(sender: UIButton!) {
        self.isInProgressClicked = false
        setUpConditionalScreen()
        //collectionView?.reloadData()
        
    }
    
    @IBAction func goToCreateRequest(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateRequest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func createCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 360, height: 84)
        
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect(x: 20, y: 227, width: 374, height: 586), collectionViewLayout: layout)
        collectionView = myCollectionView
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(MyRequestsCell.self, forCellWithReuseIdentifier: "MyRequestsCell")
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(myCollectionView)

    }
    
    
    func fetchMyRequestsFromFirebase() {
        DispatchQueue.main.async {
            self.listOfUnfulfilledRequests = []
            self.db.collection("users").document(self.userID)
            .addSnapshotListener { documentSnapshot, error in
                print("inside snapshot")
                self.listOfUnfulfilledRequests = []
                guard let document = documentSnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                if let myRequests = data["myRequests"] as? [DocumentReference] {
                    for request in myRequests {
                        request.getDocument(completion: { document, error in
                            guard let requestData = document?.data() else {
                                print("Document data was empty.")
                                return
                            }
                            var itemsToAdd = [DashboardRequestModel.ShoppingItem]()
                            for item in requestData["items"] as! [[String: Any]] {
                                let shoppingItem = DashboardRequestModel.ShoppingItem(title: item["title"] as! String, extraInfo: item["extraInfo"] as! String == "" ? nil : item["extraInfo"] as? String, picture: nil)
                                itemsToAdd.append(shoppingItem)
                            }
                            let requestToAdd = DashboardRequestModel(namePerson: requestData["nameOfPerson"] as! String, nameRequest: requestData["nameOfRequest"] as! String, store: requestData["storeName"] as! String == "" ? nil : requestData["storeName"] as? String , numberOfItems: requestData["numItems"] as! Int, items: itemsToAdd)
                            self.listOfUnfulfilledRequests.append(requestToAdd)
                            self.collectionView?.reloadData()
                        })
                    }
                }

                
            }
        }
    }
    
    
    func clearScreen() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
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
    
    
    func setUpEmptyScreen() {
        //set up background
        self.navigationController?.isNavigationBarHidden = true
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        let color1 = UIColor(red:157.0/255.0, green: 115.0/255.0, blue:195.0/255.0, alpha:0.8)
        let color2 = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:0.8)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        self.view.layer.insertSublayer(gradient, at:0)
        
        //set up image
        let logo = UIImage(named: "logo.PNG")
        let logoView = UIImageView(image: logo!)
        logoView.frame = CGRect(x: 140, y: 230, width: 140, height: 140)
        self.view.addSubview(logoView)
        
        //set up labels
        let topLabel = UILabel(frame: CGRect(x: 90, y: 410, width: 299, height: 60))
        topLabel.textAlignment = .center
        topLabel.text = "You have no requests\ncurrently."
        topLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        topLabel.numberOfLines = 2
        topLabel.sizeToFit()
        self.view.addSubview(topLabel)
        
        //set up button
        let button = UIButton(frame: CGRect(x: 110, y: 500, width: 205, height: 50))
        button.backgroundColor = .green
        button.setTitle("Add Request", for: .normal)
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(goToCreateRequest), for: .touchUpInside)
        
        //create drop shadow effect for login button
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.masksToBounds = false
        
        let buttonColor1 = UIColor(red: 82.0/255.0, green: 152.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let buttonColor2 = UIColor(red: 15.0/255.0, green: 55.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        button.applyGradient(colors: [buttonColor1.cgColor, buttonColor2.cgColor])

        self.view.addSubview(button)
    }
    
    
    @objc func goToCreateRequest(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "CreateRequest", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "createRequestNavController") as! UINavigationController
        let first = navController.viewControllers.first as! CreateNewRequestScreen
        first.tabBar = tabBarController
        
        let navController2 = tabBarController?.viewControllers?[0] as! UINavigationController
        let first2 = navController2.viewControllers.first as! InitialDashboardScreen
        
        first.delegate = first2
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension InitialMyItemsScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !isInProgressClicked ? listOfUnfulfilledRequests.count : listOfRequestsInProgress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRequestsCell", for: indexPath) as! MyRequestsCell
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0).cgColor
        cell.contentView.layer.masksToBounds = false
        
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 18, width: 100, height: 50)
        title.text = !isInProgressClicked ? listOfUnfulfilledRequests[indexPath.row].nameOfRequest : listOfRequestsInProgress[indexPath.row].nameOfRequest
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        title.sizeToFit()
        cell.contentView.addSubview(title)
        
        let numItems = UILabel()
        numItems.frame = CGRect(x: 20, y: 49, width: 100, height: 50)
        numItems.text = "\(!isInProgressClicked ? listOfUnfulfilledRequests[indexPath.row].numberOfItems : listOfRequestsInProgress[indexPath.row].numberOfItems) items"
        numItems.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        numItems.sizeToFit()
        cell.contentView.addSubview(numItems)
        
        let rightArrow = UIImageView()
        rightArrow.clipsToBounds = true
        rightArrow.image = UIImage(named: "right-arrow")
        rightArrow.frame = CGRect(x: cell.contentView.frame.maxX - 45, y: cell.contentView.frame.midY - 31/2.0, width: 31, height: 31)
        cell.contentView.addSubview(rightArrow)
        
        //create drop shadow
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 3.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MyItems", bundle: nil)
        if !isInProgressClicked {
            let vc = storyboard.instantiateViewController(withIdentifier: "SingleMyRequestView") as! SingleMyRequestView
            vc.request = listOfUnfulfilledRequests[indexPath.row]
            vc.indexPath = indexPath
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "YourShopperIsScreen") as! YourShopperIsScreen
            vc.request = listOfRequestsInProgress[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //highlight cell when pressed
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? MyRequestsCell {
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5)
            }
        }
    }

    //unhighlight cell
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? MyRequestsCell {
                cell.contentView.backgroundColor = .white
            }
        }
    }
    
    
    //pass data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "goToCreateRequestFromPopulatedMyItems" {
            let navController = segue.destination as! UINavigationController
            let firstView = navController.viewControllers.first as! CreateNewRequestScreen
            firstView.tabBar = tabBarController
            
            let navController2 = tabBarController?.viewControllers?[0] as! UINavigationController
            let first2 = navController2.viewControllers.first as! InitialDashboardScreen
            firstView.delegate = first2
        }
    }

}


extension InitialMyItemsScreen: SingleMyRequestViewDelegate {
    func deleteRequestOnTap(at index: IndexPath) {
        let navController2 = tabBarController?.viewControllers?[0] as! UINavigationController
        let first2 = navController2.viewControllers.first as! InitialDashboardScreen
        
        if let dashboardIndex = first2.requests.firstIndex(of: listOfUnfulfilledRequests[index.row]) {
            first2.requests.remove(at: dashboardIndex)
            first2.listOfRequests.deleteRows(at: [IndexPath(row: dashboardIndex, section: 0)], with: .automatic)
        }
        
        listOfUnfulfilledRequests.remove(at: index.row)
        collectionView?.reloadData()
        setUpConditionalScreen()
    }
}

