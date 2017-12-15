//
//  CustomReusableView.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/15/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import CoreData

class CustomReusableView: UICollectionReusableView {
    
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayOfCoreFolder = [CoreFolder]()
    var context: NSManagedObjectContext? = nil
    let cellID = "reusableCollectionViewCell"
    var layout: UICollectionViewFlowLayout!
    override func awakeFromNib() {
        super.awakeFromNib()
        if label != nil{
            self.label.setGoldAttributedTitle(title: "Media")
        }
        
        if collectionView != nil{
            let nib = UINib(nibName:"ResuableCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: cellID)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .black
            layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let width = 150
            let height = 48
            layout.itemSize = CGSize(width:width,height:height)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stack = appDelegate.stack
            context = stack?.context
            
            let fetchReuqest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreFolder")
            let predicate: NSPredicate? = nil
            fetchReuqest.predicate = predicate
            context?.perform {
                do{
                    if let results = try self.context?.fetch(fetchReuqest) as? [CoreFolder]{
                        self.arrayOfCoreFolder = results
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }catch{
                    print("error with the fetch")
                }
            }
        }
    }
    
    func getFolderForPoint(point: CGPoint)-> CoreFolder?{
        guard let indexPath = collectionView.indexPathForItem(at: point) else{
            return nil
        }
        let folder = arrayOfCoreFolder[indexPath.row]
        return folder
    }
    
}

extension CustomReusableView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCoreFolder.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReusableCollectionViewCell
        
        let folder = arrayOfCoreFolder[indexPath.row]
        cell.folderNameLabel.setGoldAttributedTitle(title:folder.title)
        return cell
    }
    
}



