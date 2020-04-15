//
//  ResetPasswordController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/20/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordController : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTF: UITextField!
    
    
    var pvm = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPasswordBtn(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let oldPassword = oldPasswordTextField.text, let newPassword = newPasswordTextField.text else{return}
        if newPasswordTextField.text != confirmNewPasswordTF.text {return}
        
        pvm.changePassword(email: email, oldPass: oldPassword, newPassword: newPassword) { (err) in
            if err != nil {
                print("problem changing password \(err)")
            }
        }
        
    }
    
    
    
    func alertUpdateProfile() {
        let ac = UIAlertController(title: "Reset Error", message: "Passwords don't match", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
}
