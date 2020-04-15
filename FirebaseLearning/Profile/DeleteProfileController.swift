//
//  DeleteProfileController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/20/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit

class DeleteProfileController : UIViewController {
    var pvm = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func deleteProfileBtn(_ sender: UIButton) {
        pvm.deleteUser { (err) in
            if err != nil {
                    print("Could not delete user")
                } else {
                    print("user deleted succesfully")
                }
            }
        
            let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInController")
            UIApplication.shared.keyWindow?.rootViewController = signIn
    }
    
}
