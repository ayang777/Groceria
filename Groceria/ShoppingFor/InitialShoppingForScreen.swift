//
//  InitialShoppingForScreen.swift
//  Groceria
//
//  Created by Angela Luo on 5/30/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class InitialShoppingForScreen: UIViewController {
    
    @Published var isShoppingFor: Bool = false
    let db = Firestore.firestore()
    let userID : String = (Auth.auth().currentUser?.uid)!
    
    var collectionView: UICollectionView?
    
    var listOfRequests: [DashboardRequestModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpConditionalScreen()
        fetchMyInProgressRequestsFromFirebase()
        if listOfRequests.count == 0 {
            isShoppingFor = false
        } else {
            isShoppingFor = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpConditionalScreen()
    }
    
    
    func fetchMyInProgressRequestsFromFirebase() {
        DispatchQueue.main.async {
            self.listOfRequests = []
            self.db.collection("users").document(self.userID)
            .addSnapshotListener { documentSnapshot, error in
                self.listOfRequests = []
                guard let document = documentSnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                if let myRequests = data["shoppingForRequests"] as? [DocumentReference] {
                    if myRequests.count == 0 {
                        self.isShoppingFor = false
                    }
                    for request in myRequests {
                        request.getDocument(completion: { document, error in
                            guard let requestData = document?.data() else {
                                print("Document data was empty.")
                                return
                            }
                            var itemsToAdd = [DashboardRequestModel.ShoppingItem]()
                            for item in requestData["items"] as! [[String: Any]] {
                                let shoppingItemUUID = UUID(uuidString: item["id"] as! String)
                                let shoppingItem = DashboardRequestModel.ShoppingItem(id: shoppingItemUUID, title: item["title"] as! String, extraInfo: item["extraInfo"] as! String == "" ? nil : item["extraInfo"] as? String, picture: nil)
                                itemsToAdd.append(shoppingItem)
                            }
                            let uuid = UUID(uuidString: request.documentID)
                            let requestToAdd = DashboardRequestModel(id: uuid, namePerson: requestData["nameOfPerson"] as! String, nameRequest: requestData["nameOfRequest"] as! String, store: requestData["storeName"] as! String == "" ? nil : requestData["storeName"] as? String , numberOfItems: requestData["numItems"] as! Int, items: itemsToAdd, userID: requestData["userID"] as! String)
                            self.listOfRequests.append(requestToAdd)
                            self.isShoppingFor = true
                            self.collectionView?.reloadData()
                             self.setUpConditionalScreen()
                        })
                    }
                     self.setUpConditionalScreen()
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
    
    func setUpConditionalScreen() {
        clearScreen()
        if isShoppingFor {
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
            
            let shoppingForLabel = UILabel(frame: CGRect(x: 38, y: 125, width: 180, height: 34))
            shoppingForLabel.textAlignment = .center
            shoppingForLabel.text = "Shopping for:"
            shoppingForLabel.textColor = UIColor(red:218.0/255.0, green:93.0/255.0, blue:102.0/255.0, alpha:1.0)
            shoppingForLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
            shoppingForLabel.sizeToFit()
            self.view.addSubview(shoppingForLabel)
            createCollectionView()
        } else {
            setUpEmptyScreen()
        }
    }
    
    
    func createCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 360, height: 84)
        
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect(x: 20, y: 177, width: 374, height: 636), collectionViewLayout: layout)
        collectionView = myCollectionView
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(ShoppingForRequestCell.self, forCellWithReuseIdentifier: "shoppingForCell")
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(myCollectionView)

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
        logoView.frame = CGRect(x: 140, y: 190, width: 140, height: 140)
        self.view.addSubview(logoView)
        
        //set up labels
        let topLabel = UILabel(frame: CGRect(x: 70, y: 351, width: 299, height: 60))
        topLabel.textAlignment = .center
        topLabel.text = "You aren't shopping for\nanyone currently."
        topLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        topLabel.numberOfLines = 2
        topLabel.sizeToFit()
        self.view.addSubview(topLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: 45, y: 430, width: 257, height: 50))
        secondLabel.textAlignment = .center
        
        secondLabel.text = "Check out the Dashboard to find requests!"
        secondLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        secondLabel.sizeToFit()
        self.view.addSubview(secondLabel)
        
        //set up button
        let button = UIButton(frame: CGRect(x: 110, y: 500, width: 205, height: 50))
        button.backgroundColor = .green
        button.setTitle("Go to Dashboard", for: .normal)
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(goToDashboard), for: .touchUpInside)
        
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
    
    
    @objc func goToDashboard(sender: UIButton!) {
        tabBarController?.selectedIndex = 0
    }

}

extension InitialShoppingForScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoppingForCell", for: indexPath) as! ShoppingForRequestCell
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0).cgColor
        cell.contentView.layer.masksToBounds = false
        
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 18, width: 100, height: 50)
        title.text = listOfRequests[indexPath.row].nameOfPerson
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        title.sizeToFit()
        cell.contentView.addSubview(title)
        
        let numItems = UILabel()
        numItems.frame = CGRect(x: 20, y: 49, width: 100, height: 50)
        numItems.text = "\(listOfRequests[indexPath.row].numberOfItems) items"
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
        let storyboard = UIStoryboard(name: "ShoppingFor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShoppingForSingleRequestView") as! ShoppingForSingleRequestView
        vc.request = listOfRequests[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //highlight cell when pressed
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ShoppingForRequestCell {
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5)
            }
        }
    }

    //unhighlight cell
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ShoppingForRequestCell {
                cell.contentView.backgroundColor = .white
            }
        }
    }

}

