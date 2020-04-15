//
//  FriendsViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/19/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, FriendDelDelegate {
    
    var userId: String?
    var userName: String?
    var userImgName: UIImage?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isFriend = [Bool]()
    var arrFriends = [UserModel]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        getAllFriends()
        
    }
    
    func deleteFriend() {
        arrFriends = []
        getAllFriends()
        collectionView.reloadData()
    }
    
    func openConversation() {
        let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogController
                vc.userId = userId!
                vc.userName = userName!
                vc.userImg = userImgName
                vc.getAllMessages(userId: userId!)
        present(vc, animated: true)
    }
    
    

    
    func getAllFriends(){
        FireBaseManager.shared.getAllFriends { [weak self] (arrOfFriends) in
            guard let array = try? arrOfFriends else {
                print("Could not get Friends")
                self!.arrFriends = []
                return
            }
            self?.arrFriends = array
            if self?.arrFriends.count == 0 {
                print("No Friends were found")
            } else {
                self?.collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFriends.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendsCollectionViewCell
        let friend = arrFriends[indexPath.row]
        let defaultImage = UIImage(named: "placeholder")!
        cell.userId = friend.userId
        cell.userImgName = friend.userImage ?? UIImage(named: "placeholder")!
        cell.userName = (friend.firstName ?? "") + " " +  (friend.lastName ?? "")
        
        cell.updateCell(img: friend.userImage ?? UIImage(named: "placeholder")!, name: friend.firstName! + " " +  friend.lastName!, id: friend.userId!)
        cell.delegate = self
        return cell
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
