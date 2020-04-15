//
//  FriendsCollectionViewCell.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/23/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

protocol FriendDelDelegate {
    func deleteFriend()
    func openConversation()
    var userId : String? {get set}
    var userName : String? {get set}
    var userImgName : UIImage? {get set}
}

class FriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var deleteFriend: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    
    var delegate : FriendsViewController?
    var userId : String?
    var userName : String?
    var userImgName : UIImage?
    var isFriend : Bool?
    
    
    func updateCell(img: UIImage, name: String, id: String){
        friendNameLbl.text = name
        userImg.image = img
        userId = id
    }
    @IBAction func openMessageView(_ sender: Any) {
        self.delegate?.userId = userId!
        self.delegate?.userName = userName!
        self.delegate?.userImgName = userImg.image!
        self.delegate?.openConversation()
    }
    @IBAction func deleteBtn(_ sender: Any) {
        guard  let id = userId else {
            return
        }
        FireBaseManager.shared.deleteFriend(friendId: id) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "Could not delete a friend")
            } else {
                print("Succesfully removed a friend")
            }
            self.delegate?.deleteFriend()
        }
    }
    
}
