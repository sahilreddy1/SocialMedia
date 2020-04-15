//
//  ProfileViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/18/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var pvm = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateProfileBtn(_ sender: UIButton) {
        let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdatingInfoViewController") as! UpdatingInfoViewController
        navigationController?.pushViewController(ctrl, animated: true)
        
       
    }
    
    @IBAction func deleteProfileBtn(_ sender: UIButton) {
        let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteProfileController") as! DeleteProfileController
        navigationController?.pushViewController(ctrl, animated: true)

        
    }
    
    @IBAction func changeProfileBtn(_ sender: UIButton) {
        let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        pvm.logOut()
        let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInController") as! SignInController
        UIApplication.shared.keyWindow?.rootViewController = signIn
    }
    
    
}
