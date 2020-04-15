//
//  UserCollectionViewCell.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/22/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol FriendsDelegate {
    func addFriend()
}

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    var userID : String?
    var delegate : UsersViewController?
    
    func updateCell(img : UIImage, name: String, id: String){
        
        nameLabel.text = name
        profileImage.image = img
        userID = id
        print("userID: \(userID)")
    }
    @IBAction func addFriendBtn(_ sender: Any) {
        guard let id = userID else { return }
        FireBaseManager.shared.addFriend(friendId: id) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "Could not add a friend")
            } else {
                print("Succesfully added a friend")
            }
            self.delegate?.addFriend()
        }
    }
}
