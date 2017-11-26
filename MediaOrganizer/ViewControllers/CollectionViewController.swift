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

    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var selectItem: UIBarButtonItem!
    var folder: Folder!
    let placeHolderText = "Notes"
    let cellID = "mediaCell"
    let reusableViewId = "ReusableView"
    var longGesture: UILongPressGestureRecognizer!
    var navigationItemEdition: UIBarButtonItem!
    let attributes = [NSAttributedStringKey.font: UIFont(name:"Helvetica", size:20)!]
    enum status:String{
        case show = "Allow Selection"//this is the normal state, when is showing the pictures
        case editing = "Erase"//when it has elements already selected
    }
    var controllerStatus:status = .show
    
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
        
        //register the reusable cell
        let nib = UINib(nibName: "Reusable", bundle: nil)
        //collectionView.register(nib, forCellWithReuseIdentifier: reusableViewId)
        collectionView.register(nib, forSupplementaryViewOfKind: suplementatryViewKind.header, withReuseIdentifier: reusableViewId)
        
        //create the plus item
        let navigationItemPlus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alertForCameraOrLibrary))
        navigationItem.rightBarButtonItem = navigationItemPlus
        //create the edit/done item
        navigationItemEdition = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(hideShowTheToolbar))
        navigationItemEdition.setTitleTextAttributes(attributes, for: .normal)
        //add the items
        let items:[UIBarButtonItem] = [navigationItemPlus,navigationItemEdition]
        navigationItem.setRightBarButtonItems(items, animated: false)
        
        //hide the toolbar
        toolBar.alpha = 0
    }
    
    
    @IBAction func selectItemAction(_ sender: UIBarButtonItem) {
        
        switch controllerStatus{
        case .show:
            //this case should not be available because the toolbar should be hiden
            print("this should not happen")
        case .editing:
            //here is where we should implement the deletion of the items
            guard let selectedItemsIndex = collectionView.indexPathsForSelectedItems else{
                return
            }
            
            if selectedItemsIndex.count == 0 {
                let alert = UIAlertController(title: nil, message: "No items have been selected", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(cancel)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                //we do not continue with the rest of the code inside this function
                break
            }
            
            //addActivityIndicator()
            let indexesToRemove = Set(selectedItemsIndex.map({$0.item}))
                
            //the function eraseMedia is lovley since it already erases the media form media array, so de data source has been updated
            folder.eraseMedia(indexesToRemove: indexesToRemove)
          
            //we remove all the selected cells
            
            //we have to set the cached attrubutes to empty so we can recalculate the layout
            let layout = collectionView.collectionViewLayout as! CustomLayout
            layout.cached = [UICollectionViewLayoutAttributes]()
            
            collectionView.deleteItems(at: selectedItemsIndex)
            layout.invalidateLayout()
           
            
            hideShowTheToolbar()
            //stopActivityIndicator()
        }
        
    }
    
    @objc func hideShowTheToolbar(){
        
        if controllerStatus == .show{
            
            navigationItemEdition.title = "Done"
            navigationItemEdition.setTitleTextAttributes(attributes, for: .normal)
            controllerStatus = .editing
            collectionView.allowsMultipleSelection = true
            UIView.animate(withDuration: 0.5, animations: {
               self.toolBar.alpha = 1
            })
            
        }else{
            //let attributes = [NSFontAttributeName: UIFont(name:"Helvetica", size:20)!]
            navigationItemEdition.title = "Edit"
            navigationItemEdition.setTitleTextAttributes(attributes, for: .normal)
            controllerStatus = .show
            collectionView.allowsMultipleSelection = false
            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.alpha = 0
            })
        }
    }
    
    
    //this function presents the imagePicker Controller to record video or take a photo
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
        var mediaArray = folder.mediaArray
        let mediaToRemove = mediaArray.remove(at: sourceIndexPath.item)
        mediaArray.insert(mediaToRemove, at: destinationIndexPath.item)
        folder.mediaArray = mediaArray
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        switch controllerStatus{
        case .show:
            let controller = storyboard?.instantiateViewController(withIdentifier: "DetailPhoto") as! DetailPhotoViewController
            controller.media = folder.mediaArray[indexPath.item]
            navigationController?.pushViewController(controller, animated: true)
        case .editing:
            print("add item to the selected items")
            let cell = collectionView.cellForItem(at: indexPath) as! MediaCollectionViewCell
            cell.selectedToErase = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MediaCollectionViewCell
        cell.selectedToErase = false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
       
        return true
    }
    
}

extension CollectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = folder.mediaArray.count
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MediaCollectionViewCell
        let media = folder.mediaArray[indexPath.item]
        cell.configureForMedia(media: media)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! CFString
        
        // we did not set the allow editions so we are saving the original movie
        if mediaType == kUTTypeImage{
            let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            //if the image is not nil we save it to the folder
            if let originalImage = originalImage{
                //we use this que to not block main thread
                DispatchQueue.global().async {
                    let media = Media(stringMediaType: Constants.mediaType.photo, photo: originalImage, videoURL: nil)
                    //we do not need to append the media to the folder the function folder.saveMedia will do that
                    let _ = self.folder.saveMedia(media: media)
                }
                
            }
        }
        
        //if mediaType == kUTTypeVideo{
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL{
            //let videoURL = URL(fileURLWithPath: path)
            DispatchQueue.global().async {
            
                let media = Media(stringMediaType: Constants.mediaType.video, photo:nil, videoURL: videoURL)
                //we do not need to append the media to the folder the function folder.saveMedia will do that
                let _ = self.folder.saveMedia(media: media)
            }
        }
       
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion:{
            //we need to invalidate layout and set the cached to empty to recalculate everything again
            let layout = self.collectionView.collectionViewLayout as! CustomLayout
            layout.cached = [UICollectionViewLayoutAttributes]()
            self.collectionView.reloadData()
            })
        }
        
        
        
    }
    
}





