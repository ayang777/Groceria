//
//  FulfilledRequestsScreen.swift
//  Groceria
//
//  Created by Angela Luo on 6/6/20.
//  Copyright © 2020 Angela Luo. All rights reserved.
//

import UIKit
import Firebase

class FulfilledRequestsScreen: UIViewController {
    
    var listOfRequests: [DashboardRequestModel] = []
    let db = Firestore.firestore()
    let userID : String = (Auth.auth().currentUser?.uid)!
    
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyCompletedRequestsFromFirebase()
        createCollectionView()

    }
    
    func fetchMyCompletedRequestsFromFirebase() {
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
                if let myRequests = data["myCompletedRequests"] as? [DocumentReference] {
                    if myRequests.count == 0 {
                       // self.isShoppingFor = false
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
                            //self.isShoppingFor = true
                            self.collectionView?.reloadData()
                        })
                    }
                }

                
            }
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
        myCollectionView.register(MyRequestsCell.self, forCellWithReuseIdentifier: "MyRequestsCell")
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(myCollectionView)

    }
    

}


extension FulfilledRequestsScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfRequests.count
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
         title.text = listOfRequests[indexPath.row].nameOfRequest
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
        let storyboard = UIStoryboard(name: "MyItems", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SingleMyRequestView") as! SingleMyRequestView
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
