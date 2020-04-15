//
//  UpdatingInfoViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/20/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UpdatingInfoViewController: UIViewController {
    
    var pvm = ProfileViewModel()
    

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func updateProfileBtn(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let userName = userNameTextField.text else {
            //alert that they dont have field filled out
            alertUpdateProfile()
            return
        }
        
        pvm.updateProfile(firstName: firstName, lastName: lastName, userName: userName)
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertUpdateProfile() {
        let ac = UIAlertController(title: "Updating Error", message: "textfields not filled in correctly", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }

    
    
}
