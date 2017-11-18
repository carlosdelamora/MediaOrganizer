//
//  CollectionViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/12/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import MobileCoreServices

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
    var longGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesTextView.delegate = self
        //double tap gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.numberOfTapsRequired = 2
        notesTextView.addGestureRecognizer(gestureRecognizer)
        
        //long gesture recognizer
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longGesture)
        
        
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
        
        //add the plus item
        let navigationItemPlus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alertForCameraOrLibrary))
        navigationItem.rightBarButtonItem = navigationItemPlus
        
    }
    
    fileprivate func presentImagePicker(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            let pickerViewController = UIImagePickerController()
            pickerViewController.sourceType = source
            pickerViewController.delegate = self
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: source){
                pickerViewController.mediaTypes = mediaTypes
            }
            present(pickerViewController, animated: true, completion: nil)
        }
    }
    
    @objc func alertForCameraOrLibrary(){
        let alert = UIAlertController(title: nil, message: "Choose the source of your media", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.presentImagePicker(source: .camera)
        })
        alert.addAction(cameraAction)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.presentImagePicker(source: .photoLibrary)
        })
        alert.addAction(photoLibrary)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer){
        switch gesture.state{
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else{
                break
            }
            
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("source indexPath \(sourceIndexPath)")
        print("destination indeXPath \(destinationIndexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
       
        return true
    }
    
}

extension CollectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let number = (folder?.photos.count ?? 0) + (folder?.videos.count ?? 0)
        return 100//number
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
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableViewId, for: indexPath) as! CustomReusableView
            
            return view
        }else{
            return UICollectionReusableView()
        }
        
        
    }
    
}

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
}