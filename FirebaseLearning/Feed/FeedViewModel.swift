//
//  FeedViewModel.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/18/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FBSDKCoreKit


class FeedViewModel: NSObject {
    //check to see if there's images posted by the user
    //make sure that theres a way to differentiate posts
    //make sure that the posts can be explicitly set to the current User and no one else
    var arrPosts = [[String : Any]]()

    let refD = Database.database().reference()
    let refS = Storage.storage().reference()
    let userID =  (Auth.auth().currentUser?.uid)
    let currentUser = Auth.auth().currentUser
    var postImg : UIImage?
    var postBody : String?
    var date : String?
    var userName : String?
    var userId : String?
    var userImg : UIImage?
    var userM : UserModel?
    var postM : PostModel?
    var postId : String?
    
    
    func numberOfRows() -> Int {
        return arrPosts.count
    }
    
    

    
 func getPosts(completionHandler: @escaping (([[String : Any]])?) -> Void){
        arrPosts = [[String:Any]]()
        FireBaseManager.shared.getAllPosts{ (posts) in
                    if posts != nil {
                        self.arrPosts = posts!.sorted(by: { ($0["timestamp"] as! Double) > ($1["timestamp"] as! Double) })
                        print(self.arrPosts)
                        completionHandler(posts)
                    } else {
                        print("no posts yet")
                    }
                }
    }
    
    
    
    func savePostImg(date: String, image: UIImage, completionHandler: @escaping (Error?) -> Void){
        let user = Auth.auth().currentUser
        let img = image
        let imgData = img.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imgName = "PostImg/\(user!.uid)/\(String(describing: date)).jpeg"
        Storage.storage().reference().child(imgName).putData(imgData!, metadata: metaData) { (data, error) in
            completionHandler(error)
        }
        
    }
    
    func getPostImg(userId: String, date: String, completionHandler: @escaping (Data?, Error?) -> Void){
        let imgName = "PostImg/\(String(describing: userId))/\(String(describing: date)).jpeg"
        Storage.storage().reference().child(imgName).getData(maxSize: 1*500*500) { (data, error) in
            completionHandler(data, error)
        }
    }
    
    func setInfoForCell(index: Int, completionHandler: @escaping (Bool, Bool, Bool)-> Void) {
        let post = arrPosts[index]
        userM = post["user"] as! UserModel?
        postM = post["post"] as! PostModel?
        postId = post["postId"] as! String?
        if userM != nil {
            userImg = userM!.userImage ?? UIImage(named: "billgates")!
            userName = "\(userM!.firstName ?? "") \(userM!.lastName ?? "")"
        }
        if postM != nil {
            date = postM?.date ?? ""
            if let img = postM?.postImage{
                postImg = img
            } else {
                postImg = nil
            }
            if let body = postM?.postBody {
                postBody = body
            } else {
                postBody = nil
            }
        }
        validateValuesBeforePassingPostInfo(postImgCheck: postImg, postBodyCheck: postBody) { (both, image, body) in
            if both && !image && !body {
                completionHandler(true, false, false)
            }
            if !both && image && !body {
                completionHandler(false, true, false)
            }
            if !both && !image && body {
                completionHandler (false, false, true)
            }
        }
    }
    
    func validateValuesBeforePassingPostInfo(postImgCheck: UIImage?, postBodyCheck: String?, completionHandler: @escaping (Bool, Bool, Bool)-> Void){
        if !(postImgCheck == nil) && !(postBodyCheck == nil){
            userImg = userImg ?? defaultUserModel.shared.userImage
            postImg = postImgCheck!
            userName = userName ?? "Default"
            postBody = postBodyCheck!
            date = date ?? ""
            completionHandler(true, false, false)
        }
        if !(postImg == nil) && postBody == nil {
            userImg = userImg ?? defaultUserModel.shared.userImage
            postImg = postImg!
            userName = userName ?? "Default"
            date = date ?? ""
            completionHandler(false, true, false)
        }
        if postImg == nil && !(postBody == nil) {
            userImg = userImg ?? defaultUserModel.shared.userImage
            userName = userName ?? "Default"
            postBody = postBodyCheck!
            date = date ?? ""
            completionHandler(false, false, true)
        }
    }
    
}
