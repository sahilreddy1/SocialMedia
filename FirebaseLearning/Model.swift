//
//  SignUpModel.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/17/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit

struct UserModel {
    let userId : String?
    let email : String?
    let password : String?
    var userImage : UIImage?
    var firstName : String?
    var lastName : String?

}

struct PostModel {
    let timestamp : Double?
    let userId : String?
    var postBody : String?
    let date : String?
    var postImage : UIImage?
    var postId : String?
}

struct User1{
    var username : String?
    var firstName : String?
    var lastName : String?

    
}

struct Posting {
    let userId : String?
    let postImage : UIImage?
    let postDescription : String?
}

struct MessageModel {
    let timestamp : Double?
    let recepientId : String?
    let date : String?
    var msgBody : String?
    let status : String?
}

