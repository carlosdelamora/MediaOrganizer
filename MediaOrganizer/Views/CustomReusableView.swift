//
//  CustomReusableView.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/15/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class CustomReusableView: UICollectionReusableView {
    
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let cellID = "reusableCollectionViewCell"
    var layout: UICollectionViewFlowLayout!
    override func awakeFromNib() {
        super.awakeFromNib()
        if label != nil{
            self.label.text = "Media"
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
        }
    }
    
    func indexPathForCellCloseToPoint(point:CGPoint)-> [IndexPath]?{
        //this should be all visible attributes
        let attributes = layout.layoutAttributesForElements(in: self.frame)
        let attributesContainOrigin = attributes?.filter({ $0.frame.contains(point) })
        let indices = attributesContainOrigin?.map({$0.indexPath})
        return indices
    }
}

extension CustomReusableView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReusableCollectionViewCell
        
        cell.folderNameLabel.text = "random"
        return cell
    }
    
}



