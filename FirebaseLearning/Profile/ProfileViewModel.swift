//
//  ProfileViewModel.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/20/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FBSDKCoreKit


class ProfileViewModel : NSObject{
    
    func updateProfile(firstName: String, lastName: String, userName: String) {
         
        let ref = Database.database().reference()
        let userID = (Auth.auth().currentUser?.uid)!
        print("in PVM user id \(userID)")
        
        let userData = [ "firstName": firstName,
                       "lastName": lastName,
                       "username": userName
                        ]
        
        ref.child("User").child(userID).updateChildValues(userData)
    }
    
    func logOut() {
        if Auth.auth().currentUser != nil {
            do {
                print("signing out")
                try Auth.auth().signOut()
            } catch{
                print("Error occured signing out, \(error.localizedDescription)")
            }
        }
    }
    
    func changePassword(email: String, oldPass: String, newPassword: String, completionHandler: @escaping (Error?) -> Void){
        if email.isValidEmail == false {
            print("invalid email")
            return
        }
        let user = Auth.auth().currentUser
        var credentials : AuthCredential
        credentials = EmailAuthProvider.credential(withEmail: email, password: oldPass)
        user?.reauthenticate(with: credentials, completion: {(authResult, error) in
            if error == nil {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completionHandler(nil)
                })
            }else{
                print("error: \(error)")
                completionHandler(error)
            }
        })
        
        
    }
    
    func deleteUser(completionHandler: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        Database.database().reference().child("User").child(user!.uid).removeValue()
        user?.delete(completion: { (err) in
            if err != nil {
                completionHandler(err)
            } else {
                completionHandler(nil)
            }
        })
    }

}
