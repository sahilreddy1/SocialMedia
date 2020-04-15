//
//  UsersViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/22/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, FriendsDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrUsers = [UserModel]()
    var arrOfFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllUsers()
        
        print(arrUsers.count)
    }
    
    func getAllUsers() {
        FireBaseManager.shared.getAllUsers { (arrUsers) in
            guard let users = try? arrUsers else{return}
            self.arrUsers = users
            print("selfarrUsers \(self.arrUsers.count)")
            if self.arrUsers.count == 0 {
                print("no users")
                return
            }else{
                self.collectionView.reloadData()
            }
        }
    }
    
    func getAllFriends(){
        FireBaseManager.shared.getAllFriends { [weak self] (array) in
            guard let friends = try? array else {
                return
            }
            for friend in friends {
                if let friendId = friend.userId {
                    self?.arrOfFriends.append(friendId)
                }
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func checkIfFriend(_ uid: String) -> Bool {
        if arrOfFriends.contains(uid){
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return arrUsers.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCollectionViewCell
         
         let user = arrUsers[indexPath.row]
         
         
        cell.updateCell(img: (user.userImage ?? defaultUserModel.shared.userImage ?? UIImage()), name: (user.firstName ?? "") + " " +  (user.lastName ?? ""), id: (user.userId ?? defaultUserModel.shared.userId))
         
        cell.addBtn.isHidden = checkIfFriend(user.userId!)
        cell.delegate = self
         
        return cell
     }
     
     func addFriend() {
         getAllFriends()
     }
    

}
