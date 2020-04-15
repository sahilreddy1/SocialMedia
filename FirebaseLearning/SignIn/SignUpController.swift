//
//  SignUpController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/16/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class SignUpController: UIViewController {
    // Firebase services
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //When user clicks on sign in to go to another controller
    @IBAction func signInClicked(_ sender: UIButton) {
         let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInController")
         ctrl.modalPresentationStyle = .fullScreen
         self.present(ctrl, animated: true, completion: nil)
    }
    
    //When User clicks sign up Button
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        //check passwords aren't the same
        let passwordValidity = checkPassword()
        if passwordValidity == false {return}
        
        //createUser Function
        createUserForFirebase()
    }
    
    func presentAlertController() {
        let ac = UIAlertController(title: "Sign Up Successful!", message: "You have successfuly signed up! Sign in to continue", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    func checkPassword() -> Bool{
        
        if passwordTextField.text == confirmPasswordTextField.text {
            return true
        }
        //present ac and return false
        let ac = UIAlertController(title: "Passwords do not match", message: "Make sure your passwords match", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
        
        return false
    }
    
    func createUserForFirebase() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            print(authResult)
//            print(error)
            let imageName = NSUUID().uuidString
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                
                let userData = ["firstName": self.firstNameTextField.text! as String ,
                                "lastName": self.lastNameTextField.text! as String,
                                "username": self.usernameTextField.text! as String
                                ]
                //var ref: DatabaseReference!
                let ref = Database.database().reference()
                ref.child("User").child((authResult?.user.uid)!).setValue(userData) { (error, ref) in
//                //can do something here
//                    self.storageRef.child("User").child((authResult?.user.uid)!)
//                    let image = UIImage(named: "placeholder")
//                    if let uploadData = image?.pngData(){
//                        self.storageRef.putData(uploadData).observe(.success) { (snapshot) in
//                            let downloadURL = snapshot.metadata?.bucket
//                            // Write the download URL to the Realtime Database
//                            let dbRef = self.databaseRef.child((authResult?.user.uid)!)
//                            dbRef.setValue(downloadURL)
//                        }
                    
//                    }
                }
                
                
                //alert controller saying you signed in
                self.presentAlertController()
            }
        }
    }
    
}
