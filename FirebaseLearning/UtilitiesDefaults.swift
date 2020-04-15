//
//  UtilitiesDefaults.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/22/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit

func roundedImg(image : UIImageView){
    image.clipsToBounds = true
    let borderColor = UIColor.blue.cgColor
    image.layer.borderColor = borderColor
    image.layer.borderWidth = 3
    image.layer.cornerRadius = image.bounds.width / 2
}


func textFieldStyle(txtField: UITextField, color: UIColor){
    let borderColor = color.cgColor
    txtField.layer.cornerRadius = 5.0
    txtField.clipsToBounds = true
    txtField.layer.borderColor = borderColor
}

func labelStyle(label: UILabel, color: UIColor){
    let borderColor = color.cgColor
    label.layer.cornerRadius = 5.0
    label.clipsToBounds = true
    label.layer.borderColor = borderColor
}

func buttonStyle(button: UIButton, color: UIColor){
    let borderColor = color.cgColor
    button.layer.cornerRadius = 5.0
    button.clipsToBounds = true
    button.layer.borderColor = borderColor
}

func testViewStyle(txtView: UITextView, color: UIColor){
    let borderColor = color.cgColor
    txtView.layer.cornerRadius = 5.0
    txtView.clipsToBounds = true
    txtView.layer.borderColor = borderColor
}

class defaultUserModel {
    static let shared = defaultUserModel()
    private init(){}
    
    let userId = "1"
    let email = "email"
    let password = "pass"
    let userImage = UIImage(named: "placeholder")
    let firstName = "Rayan"
    let lastName = "Reynolds"
 
    
}

class defaultPostModel {
    static let shared = defaultPostModel()
    private init(){}
    let timestamp = 0.0
    let userId = "1"
    let postBody = "Good Morning"
    let postImage = UIImage(named: "camera")
    let postId = "1"
}

func generateDate() ->String {
    let date = Date()
    let dateFormatter = DateFormatter()
    var dateId : String = ""
    dateFormatter.dateFormat = "MMMM-dd-yyyy HH:mm"
    dateId = dateFormatter.string(from: date)
    return dateId
}


extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
}
