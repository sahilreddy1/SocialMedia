//
//  FeedCollectionViewCell.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/23/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescription: UILabel!
    
    var delegate : FeedViewController?
    
    func updateCellWOImg(userImg: UIImage, userName: String, postBody: String, date: String){
        self.profileImage.image = userImg
        self.nameLabel.text = userName
        self.postDescription.text = postBody
        
        
        
    }
    func updateCellWOText(userImg: UIImage, postImg: UIImage, userName: String, date: String){
        self.profileImage.image = userImg
        self.postImage.image = postImg
        self.nameLabel.text = userName
        
        
    }
    
    func updateCell(userImg: UIImage, postImg: UIImage, name: String, postBody: String, date: String){
        
        nameLabel.text = name
        profileImage.image = userImg
        postImage.image = postImg
        postDescription.text = postBody
        
    }
    
    
}
