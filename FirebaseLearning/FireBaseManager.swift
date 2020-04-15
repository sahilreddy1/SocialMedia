//
//  FireBaseManager.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/22/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FBSDKCoreKit


class FireBaseManager {
    static let shared = FireBaseManager()
    private init (){}
    
    let refD = Database.database().reference()
    let refS = Storage.storage().reference()
    
//sign in
    func signIn(email: String, password: String, completionHandler: @escaping (Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error occured")
                completionHandler(error)
            } else {
                if let user = user?.user {
                    print(user.uid)
                }
                completionHandler(nil)
            }
        }
    }
    
//reset password
    func resetPassword(email: String, completionHandler: @escaping (Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completionHandler(error)
        }
    }


//change Password
    func changePassword(email: String, oldPass: String, password: String, completionHandler: @escaping (Error?) -> Void){
        let user = Auth.auth().currentUser
        var credentials : AuthCredential
        credentials = EmailAuthProvider.credential(withEmail: email, password: oldPass)
        user?.reauthenticateAndRetrieveData(with: credentials, completion: {(authResult, error) in
            if error == nil {
                Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
                    completionHandler(nil)
                })
            }else{
                completionHandler(error)
            }
        })
        
        
    }

   

    
    
//delete user
    func deleteUser(completionHandler: @escaping (Error?) -> Void){
        let user = Auth.auth().currentUser
        refD.child("User").child(user!.uid).removeValue()
        user?.delete { error in
            if error != nil {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
//log out
    func signOut(){
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch{
                print("Error occured signing out, \(error.localizedDescription)")
            }
        }
    }
    
//create a user and sign in
    func createUser(user : UserModel, completionHandler: @escaping (Error?) -> Void){
        Auth.auth().createUser(withEmail: user.email!, password: user.password!) { (response, error) in
            if error != nil {
                completionHandler(error)
            } else {
                if let response = response?.user {
                    print("user successfully added, \(response.uid)")
                    let userDict = ["userId": response.uid, "email": user.email as Any, "password": user.password as Any, "name": user.firstName as Any, "lastName": user.lastName as Any] as [String : Any]
                    self.refD.child("User").child(response.uid).setValue(userDict){(error1, ref) in
                        if error == nil{
                            Auth.auth().signIn(withEmail: userDict["email"] as! String, password: userDict["password"] as! String, completion: { (newUser, error) in
                                if error == nil {
                                    print("succesfully signed in")
                                    completionHandler(nil)
                                } else {
                                    completionHandler(error)
                                }
                            })
                        } else {
                            completionHandler(error1)
                        }
                    }
                }
            }
        }
    }
    
    
//users functionality
//user images services
    func saveUserImg(image: UIImage, completionHandler: @escaping (Error?) -> Void){
        let user = Auth.auth().currentUser
        let imageData = image.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = "UserImg/\(String(describing: user!.uid)).jpeg"
        self.refS.child(imageName).putData(imageData!, metadata: metaData) {(data, error) in
            completionHandler(error)
        }
    }
    
    func getUserImg(completionHandler: @escaping (Data?, Error?) -> Void){
        let user = Auth.auth().currentUser
        
        let imageName = "UserImg/\(String(describing: user!.uid)).jpeg"
        refS.child(imageName).getData(maxSize: 1*500*500, completion: {(data, error) in
            completionHandler(data, error)
        })
    }
    
    func getUserImgById(id: String, completionHandler: @escaping (Data?, Error?)->Void){
        let imageName = "UserImg/\(id).jpeg"
        refS.child(imageName).getData(maxSize: 1*500*500, completion: {(data, error) in
            completionHandler(data, error)
        })
    }
    
//get user Info
    func getUserData(completionHandler: @escaping (UserModel?) -> Void){
        let user = Auth.auth().currentUser
        //get userinfo based on user id
        refD.child("User").child(user!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let snap = snapshot.value as? [String : Any] else {
                    completionHandler(nil)
                    return
            }
            let userM = UserModel(userId: user!.uid, email: snap["email"] as? String, password: snap["password"] as? String, userImage: UIImage(named: "placeholder"), firstName: snap["firstName"] as? String, lastName: snap["lastName"] as? String)
            completionHandler(userM)
        })
    }
    
    func getUserById(userId: String, completionHandler: @escaping (UserModel?) -> Void){
        refD.child("User").child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let snap = snapshot.value as? [String : Any] else {
                    completionHandler(nil)
                    return
                }
            self.getUserImgById(id: userId, completionHandler: {(data, error) in
                print(error?.localizedDescription)
                    if error == nil && !(data == nil) {
                        let user = UserModel(userId: userId, email: snap["email"] as? String, password: snap["password"] as? String, userImage: UIImage(named: "placeholder"), firstName: snap["firstName"] as? String, lastName: snap["lastName"] as? String)
                        completionHandler(user)
                    }
                    else {
                        let user = UserModel(userId: userId, email: snap["email"] as? String, password: snap["password"] as? String, userImage: UIImage(named: "placeholder"), firstName: snap["firstName"] as? String, lastName: snap["lastName"] as? String)
                        completionHandler(user)
                }
            })
        })
    }
//update user info
    func updateUser(user: UserModel, completionHandler: @escaping (Error?) -> Void) {
        let userID = (Auth.auth().currentUser?.uid)!
        let userDict = ["name": user.firstName!, "email" : user.email!, "password" : user.password!, "lastName": user.lastName as Any] as [String : Any]
        refD.child("User").child(userID).updateChildValues(userDict) {(error, ref) in
            if error != nil{
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
//get all users
    func getAllUsers(completionHandler: @escaping ([UserModel]) -> Void){
        let currentUser = Auth.auth().currentUser
        let fetchUserGroup = DispatchGroup()
        let fetchUserComponentGroup = DispatchGroup()
        
        fetchUserGroup.enter()
        refD.child("User").observeSingleEvent(of: .value) {(snapshot, error) in
            if error != nil {
                print(error ?? "Error happened fetching users")
            } else {
                var userArr = [UserModel]()
                guard let response = snapshot.value as? [String : Any] else {
                    return
                }
                for record in response {
                    let uid : String = record.key
                    if currentUser!.uid != uid {
                        let user = response[uid] as! [String : Any]
                        print(user)
                        var userM = UserModel(userId: uid, email: user["email"] as? String, password: user["password"] as? String, userImage: nil, firstName: user["firstName"] as? String, lastName: user["lastName"] as? String)
                        fetchUserComponentGroup.enter()
                        self.getUserImgById(id: uid) { (data, error) in
                            if error == nil && !(data == nil){
                                userM.userImage = UIImage(data: data!) ?? UIImage()
                            }
                            else {
                                userM.userImage = UIImage(named: "placeholder")
                            }
                            userArr.append(userM)
                            fetchUserComponentGroup.leave()
                        }
                    }
                }
                fetchUserComponentGroup.notify(queue: .main){
                    fetchUserGroup.leave()
                }
                fetchUserGroup.notify(queue: .main){
                    completionHandler(userArr)
                }
            }
        }
    }
    
//friends functionality
//get all friends
    func getAllFriends(completionHandler: @escaping ([UserModel]) -> Void){
         let currentUser = Auth.auth().currentUser
         var friendArr = [UserModel]()
         let friendDispatchGroup = DispatchGroup()
         refD.child("User").child(currentUser!.uid).child("Friends").observeSingleEvent(of: .value) { (snapshot) in
             if let friends = snapshot.value as? [String : Any] {
                 for friend in friends {
                     friendDispatchGroup.enter()
                    self.refD.child("User").child(friend.key).observeSingleEvent(of: .value) { (friendSnapshot) in
                         guard let singleFriend = friendSnapshot.value as? [String : Any] else {return}
                         var userM = UserModel(userId: friend.key, email: singleFriend["email"] as? String, password: singleFriend["password"] as? String, userImage: nil, firstName: singleFriend["firstName"] as? String, lastName: singleFriend["lastName"] as? String)
                         self.getUserImgById(id: userM.userId!) { (data, error) in
                             if error == nil && !(data == nil){
                                 userM.userImage = UIImage(data: data!) ?? UIImage()
                             }
                            else {
                                userM.userImage = UIImage(named: "placeholder")
                            }
                             friendArr.append(userM)
                             friendDispatchGroup.leave()
                         }
                     }
                    friendDispatchGroup.notify(queue: .main){
                        completionHandler(friendArr)
                    }
                 }
                 
             }
         }
     }
    
    func addFriend(friendId: String, completionHandler: @escaping (Error?) -> Void) {
           let curUser = Auth.auth().currentUser
        refD.child("User").child((curUser?.uid)!).child("Friends").child(friendId).updateChildValues([friendId : "friendId"] ){(error, ref) in
               completionHandler(error)
           }
       }
    
    func deleteFriend(friendId: String, completionHandler: @escaping (Error?) -> Void){
        let curUser = Auth.auth().currentUser
        refD.child("User").child((curUser?.uid)!).child("Friends").child(friendId).removeValue(){(error, ref) in
            completionHandler(error)
        }
    }
    
//posts functionality
//signle post
    func uploadPost (post: PostModel, completionHandler: @escaping (Error?) -> Void){
        let postKey = refD.child("Posts").childByAutoId().key
        let postDict = ["postId" : postKey!, "userId" : post.userId!, "postBody" : post.postBody!, "date" : post.date!, "timestamp" : post.timestamp as Any] as [String : Any]
        refD.child("User").child(post.userId!).child("Posts").child(postKey!).setValue(postDict)
        refD.child("Posts").child(postKey!).setValue(postDict)
            { (error, ref) in
            completionHandler(error)
        }
        
    }
    
    func updatePost(post: PostModel, completionHandler: @escaping (Error?) -> Void){
        let postDict = ["postId" : post.postId!, "userId" : post.userId!, "postBody" : post.postBody!, "date" : post.date!, "timestamp" : post.timestamp as Any] as [String : Any]
        refD.child("Posts").child(postDict["postId"] as! String).updateChildValues(postDict){(error, ref) in
            if error == nil{
                completionHandler(nil)
            } else {
                completionHandler(error)
            }
        }
    }
    
    func deletePost(postId: String, completionHandler: @escaping (Error?) -> Void){
        refD.child("Posts").child(postId).removeValue(){(error, ref) in
            if error == nil{
            completionHandler(nil)
            } else {
                completionHandler(error)
            }
        }
    }
    
//all posts functions
    func getAllPostsByUserId(id: String, completionHandler: @escaping ([PostModel]?) -> Void){
        let postGroup = DispatchGroup()
        let imageGroup = DispatchGroup()

        postGroup.enter()
        refD.child("Posts").observeSingleEvent(of: .value) { (snapshot) in
            var arrPosts = [PostModel]()
            if let posts = snapshot.value as? [String : Any]{
                for record in posts {
                    let pid = record.key
                    let post = posts[pid] as! [String : Any]
                    var postM = PostModel(timestamp: post["timestamp"] as? Double, userId: post["userId"] as? String, postBody: post["postBody"] as? String, date: post["date"] as? String, postImage: nil, postId: pid)
                    imageGroup.enter()
                    self.getPostImg(userId: postM.userId!, date: postM.date!) { (data, error) in
                        if error == nil && !(data == nil) {
                            postM.postImage = UIImage(data: data!)
                        }
                       if postM.userId == id {
                           arrPosts.append(postM)
                       }
                    imageGroup.leave()
                    }
                }
                imageGroup.notify(queue: .main){
                    postGroup.leave()
                }
                postGroup.notify(queue: .main){
                    completionHandler(arrPosts)
                }
            }
        }
    }
    
    func
        getAllPosts(completionHandler: @escaping ([[String : Any]]?) -> Void){
        let postsDispatchGroup = DispatchGroup()
        let userDispatchGroup = DispatchGroup()
        var postsArr = [[String : Any]]()
        refD.child("Posts").observeSingleEvent(of: .value) { (snapshot, error) in
            if error == nil {
                guard let response = snapshot.value as? [String : Any] else {
                    completionHandler(nil)
                    return
                }
                for record in response {
                    var postDict = [String : Any]()
                    postsDispatchGroup.enter()
                    let pid = record.key
                    let post = response[pid] as! [String : Any]
                    userDispatchGroup.enter()
                    self.getUserById(userId: post["userId"] as! String) { (user) in
                
                            postDict["user"] = user
                        userDispatchGroup.leave()
                    }
                    var postM = PostModel(timestamp: post["timestamp"] as? Double, userId: post["userId"] as? String, postBody: post["postBody"] as? String, date: post["date"] as? String, postImage: nil, postId: post["postId"] as? String)
                    
                    postDict["postId"] = pid
                    postDict["timestamp"] = postM.timestamp
                    
                    self.getPostImg(userId: postM.userId!, date: postM.date!) { (data, error) in
                        if !(data == nil) && error == nil{
                            postM.postImage = UIImage(data: data!)
                        }
                        
                        postDict["post"] = postM
                        
                    }
                    userDispatchGroup.notify(queue: .main){
                        postsArr.append(postDict)
                        postsDispatchGroup.leave()
                    }
                }
                postsDispatchGroup.notify(queue: .main){
                    completionHandler(postsArr)
                }
            }
            
        }
    }
    


//post image functionality
//save image
    func savePostImg(date: String, image: UIImage, completionHandler: @escaping (Error?) -> Void){
        let user = Auth.auth().currentUser
        let img = image
        let imgData = img.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imgName = "PostImg/\(user!.uid)/\(String(describing: date)).jpeg"
        refS.child(imgName).putData(imgData!, metadata: metaData) { (data, error) in
            completionHandler(error)
        }
    }
   
    
    func getPostImg(userId: String, date: String, completionHandler: @escaping (Data?, Error?) -> Void){
        let imgName = "PostImg/\(String(describing: userId))/\(String(describing: date)).jpeg"
        refS.child(imgName).getData(maxSize: 1*500*500) { (data, error) in
            completionHandler(data, error)
        }
    }
 
//messages functionality
    func sendMessage(msgModel : MessageModel, completionHandler: @escaping (Error?) -> Void){
        let uid = Auth.auth().currentUser?.uid
        let messageId = refD.child("Users").child(uid!).child("Chats").child(msgModel.recepientId!).childByAutoId().key
        let senderDict = ["timestamp": msgModel.timestamp!, "recepientId": msgModel.recepientId!, "date" : msgModel.date!, "msgBody": msgModel.msgBody!, "status": msgModel.status!] as [String : Any]
        let recepientDict = ["timestamp": msgModel.timestamp!, "recepientId": msgModel.recepientId!, "date" : msgModel.date!, "msgBody": msgModel.msgBody!, "status": "received"] as [String : Any]
        refD.child("User").child(uid!).child("Chats").child(msgModel.recepientId!).child(messageId!).setValue(senderDict){(error, ref) in
            if error != nil {
                print("Succesfully sent a message")
            } else {
                completionHandler(error)
            }
        }
        refD.child("User").child(msgModel.recepientId!).child("Chats").child(uid!).child(messageId!).setValue(recepientDict){(error, ref) in
            if error != nil {
                print("Succesfully sent a message")
            } else {
                completionHandler(error)
            }
        }

    }
    
    
    func getAllMsgsForChat(recepientId: String, completionHandler: @escaping  ([[String : Any]]?) -> Void){
        let uid = Auth.auth().currentUser?.uid
        let chatsGroup = DispatchGroup()
//        let singlePost = DispatchGroup()
        var chatsArray = [[String : Any]]()

        chatsGroup.enter()
        refD.child("User").child(uid!).child("Chats").child(recepientId).observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print(error ?? "Error happened fetching chats")
            } else {
                guard let records = snapshot.value as? [String : Any] else { return }
                for record in records {
                    let cid = record.key
                    let chat = records[cid] as! [String : Any]
                    var chatDict = [String: Any]()
                    let chatM = MessageModel(timestamp: chat["timestamp"] as? Double, recepientId: chat["recepientId"] as? String, date: chat["date"] as? String, msgBody: chat["msgBody"] as? String, status: chat["status"] as? String)
                    chatDict["timestamp"] = chat["timestamp"] as? Double
                    chatDict["msgModel"] = chatM
                    chatsArray.append(chatDict)
                }
            }
            chatsGroup.leave()
        }
        chatsGroup.notify(queue: .main){
            completionHandler(chatsArray)
        }
    }
    
    
    func getAllConversationsForUser(completionHandler: @escaping ([[String : Any]]?) -> Void){
        let currentUser = Auth.auth().currentUser
        let usersGroup = DispatchGroup()
//        let componentsUserGroup = DispatchGroup()
        var arrOfUsersWithConv = [[String: Any]]()
        
        refD.child("User").child(currentUser!.uid).child("Chats").observeSingleEvent(of: .value) { (snapshot) in
            if let conversations = snapshot.value as? [String : Any]{
                for conversation in conversations {
                    usersGroup.enter()
                    self.refD.child("User").child(conversation.key).observeSingleEvent(of: .value) { (userSnapshot) in
                        var userDict = [String : Any]()
                        guard let singleUser = userSnapshot.value as? [String : Any] else {
                            return}
                        userDict["name"] = singleUser["name"] as? String
                        userDict["lastName"] = singleUser["lastName"]
                        userDict["userId"] = singleUser["userId"]
                        self.getUserImgById(id: userDict["userId"] as! String) { (data, error) in
                            if error == nil && !(data == nil){
                                userDict["userImg"] = UIImage(data: data!) ?? UIImage()
                            }
//                            if error == nil && data == nil {
//                                userDict["userImg"] = defaultImg(gender: (singleUser["gender"] as? String)!)
//                            }
                            arrOfUsersWithConv.append(userDict)
                            usersGroup.leave()
                        }
                    }
                }
                usersGroup.notify(queue: .main){
                    completionHandler(arrOfUsersWithConv)
                }
            }
            
        }
    }
    
    
}
