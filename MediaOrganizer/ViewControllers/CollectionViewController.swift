//
//  CollectionViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/12/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

struct suplementatryViewKind{
    static let header = "Header"
}

class CollectionViewController: UIViewController {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var folder: Folder?
    let placeHolderText = "Notes"
    let cellID = "mediaCell"
    let reusableViewId = "ReusableView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesTextView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(gestureRecognizer)
        //set the layout
        let layout = collectionView.collectionViewLayout as! CustomLayout
        layout.numberOfColumns = 3
        layout.padding = 1.0
        //collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        //register the reusable cell
        let nib = UINib(nibName: "Reusable", bundle: nil)
        //collectionView.register(nib, forCellWithReuseIdentifier: reusableViewId)
        collectionView.register(nib, forSupplementaryViewOfKind: suplementatryViewKind.header, withReuseIdentifier: reusableViewId)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}


extension CollectionViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.text == placeHolderText{
            notesTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        folder?.notes = textView.text
    }
}

extension CollectionViewController: UICollectionViewDelegate{
    
}

extension CollectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let number = (folder?.photos.count ?? 0) + (folder?.videos.count ?? 0)
        return 30//number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MediaCollectionViewCell
        cell.backgroundColor = .blue
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == suplementatryViewKind.header{
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableViewId, for: indexPath) 
            return view
        }else{
            return UICollectionReusableView()
        }
        
        
    }
    
}
