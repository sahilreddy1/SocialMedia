//
//  MessagesViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/21/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sentMsgText: UITextView!
    @IBOutlet weak var receivedMsgTxt: UITextView!
    
    

    func updateCell(msgBody: String, status: String){
        receivedMsgTxt.isHidden = true
        sentMsgText.isHidden = true
        
        if status == "send"{
            receivedMsgTxt.isHidden = true
            sentMsgText.isHidden = false
            sentMsgText.text = msgBody
        }
        if status == "received"{
            sentMsgText.isHidden = true
            receivedMsgTxt.isHidden = false
            receivedMsgTxt.text = msgBody
        }
    }
}
