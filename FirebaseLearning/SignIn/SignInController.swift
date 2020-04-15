//
//  ViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/16/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let signVM = SignViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print("authResult: \(authResult)")
            print("error: \(error)")
            
            if error == nil {
//                let appDelegate = UIApplication.shared.delegate as! SceneDelegate
//                appDelegate.switchBack()
               let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarController") 
                UIApplication.shared.keyWindow?.rootViewController = signIn
                print("make tab bar root")
            }
        }
        
    }
    @IBAction func signUpClicked(_ sender: UIButton) {
        print("Sign Up Clicked")
        let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpController") 
        ctrl.modalPresentationStyle = .fullScreen
        self.present(ctrl, animated: true, completion: nil)
    }
    
    func presentAlertController() {
        let ac = UIAlertController(title: "Sign Up Successful!", message: "You have successfuly signed up! Sign in to continue", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    

}

