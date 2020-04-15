//
//  HomeViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/16/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var globalData : Data?
    var fvm = FeedViewModel()
    let dateID = generateDate()
    var postingImage : UIImage?
    let timestamp = NSDate().timeIntervalSince1970
    
    let currUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func postToFirebase(_ sender: UIButton) {
        savePost()
        navigationController?.popViewController(animated: true)
    }
    
    func savePost(){
        if imgView.image == nil{
            print("nothing in image first choose image")
            return
        }
        guard let postDescription = textView.text else{
            print("nothing in description")
            return
        }
        let postM = PostModel(timestamp: timestamp, userId: currUser?.uid, postBody: textView.text, date: dateID, postImage: nil, postId: nil)
        FireBaseManager.shared.uploadPost(post: postM) { (error) in
        if error == nil {
            print("Succesfully uploaded and updated image \(self.dateID)")
        } else {
            print(error?.localizedDescription ?? "Couldnt save image")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        //1. init
        let imgPickerController = UIImagePickerController()
        //2 set delegate
        imgPickerController.delegate = self
        
        //3. present
        present(imgPickerController, animated: true, completion: nil)
        
    }

    
    
    
    //didfinish
    //5a implement didFinishPickingMediaWithInfo delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            print("No image found")
            return
        }
        FireBaseManager.shared.savePostImg(date: dateID, image: image) { (error) in
            if error == nil {
                self.imgView.image = image
                
                print("Succesfully saved image")
            } else {
                print(error?.localizedDescription ?? "Couldnt save image")
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    //5b. implement imagePickerControllerDidCancel delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
