//
//  FeedViewController.swift
//  FirebaseLearning
//
//  Created by Sahil Reddy on 3/18/20.
//  Copyright © 2020 Sahil Reddy. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class FeedViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var fvm = FeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getPosts()
    }
    
    
    @IBAction func goToPostVC(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(identifier: "PostViewController"))!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getPosts(){
        fvm.getPosts { (_) in
            
//            if self.arrPosts.count == 0 {
//                print("no Posts")
//                return
//            }else{
//                self.collectionView.reloadData()
//            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fvm.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedCollectionViewCell
            
            guard indexPath.row < fvm.numberOfRows() else { return FeedCollectionViewCell()}
            
            fvm.setInfoForCell(index: indexPath.row) { (both, image, body) in
                if both && !image && !body {
                    cell.updateCell(userImg: self.fvm.userImg!, postImg: self.fvm.postImg!, name: self.fvm.userName!, postBody: self.fvm.postBody!, date: self.fvm.date!)
                }
                if !both && image && !body {
                    cell.updateCellWOText(userImg: self.fvm.userImg!, postImg: self.fvm.postImg!, userName: self.fvm.userName!, date: self.fvm.date!)
                }
                if !both && !image && body {
                    cell.updateCellWOImg(userImg: self.fvm.userImg!, userName: self.fvm.userName!, postBody: self.fvm.postBody!, date: self.fvm.date!)
                }
                
            }
            return cell
        }
    
    
    
    
}
