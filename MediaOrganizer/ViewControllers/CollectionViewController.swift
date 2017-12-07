//
//  CollectionViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/12/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//
import AVKit
import UIKit
import MobileCoreServices
import CoreData

struct suplementatryViewKind{
    static let header = "Header"
}

class CollectionViewController: UIViewController {
    
    //Properties
    var folder: CoreFolder!
    var mediaArray = [CoreMedia]()
    var documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let placeHolderText = "Notes..."
    let cellID = "mediaCell"
    let reusableViewId = "ReusableView"
    var longGesture: UILongPressGestureRecognizer!
    var navigationItemEdition: UIBarButtonItem!
    
    enum status:String{
        case show = "Allow Selection"//this is the normal state, when is showing the pictures
        case editing = "Erase"//when it has elements already selected
    }
    var controllerStatus:status = .show
    
    //core data
    var context: NSManagedObjectContext? = nil
    
    //Outlets
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var trashButtonItem: UIBarButtonItem!
    @IBOutlet weak var notesButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle constraint animmation
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        
        //coreData context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stack = appDelegate.stack
        context = stack?.context
        
        //set the coreMedia
        mediaArray = folder.mediaArray()
        
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
        navigationItemEdition = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(hideShowTheToolbar))
        navigationItemEdition.setTitleTextAttributes(Constants.fontAttributes.navigationItem, for: .normal)
        
        //add the items
        let items:[UIBarButtonItem] = [navigationItemPlus,navigationItemEdition]
        navigationItem.setRightBarButtonItems(items, animated: false)
        
        //hide the trahButton
        self.trashButtonItem.isEnabled = false
        self.trashButtonItem.tintColor = .clear
        
        //set the collection view to cover the notes
        let newY:CGFloat = 64
        let newHeight = view.frame.height - 64
        notesTextView.isHidden = true
        let rect = CGRect(x: 0, y: newY, width: view.frame.width, height: newHeight)
        collectionView.frame = rect
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let notes = folder.notes{
            notesTextView.text = notes
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //dismiss if the keyboard is present dismissed so the folder can be saved
        self.view.endEditing(true)
        
    }
    
    //MARK - IBAction
    @IBAction func notesBarButtonAction(_ sender: Any) {
        var newHeight: CGFloat
        var newY:CGFloat
        if collectionView.frame.origin.y > 64 {
            newY = 64
            newHeight = view.frame.height - 64
            notesTextView.isHidden = true
        }else{
            newY = notesTextView.frame.maxY
            newHeight = view.frame.height - newY
            notesTextView.isHidden = false
        }
        let rect = CGRect(x: 0, y: newY, width: view.frame.width, height: newHeight)
        UIView.animate(withDuration: 1, animations: {
            self.collectionView.frame = rect
        })
    }
    
    
    @IBAction func trashButtonWasPressed(_ sender: UIBarButtonItem) {
        
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
            }
            
            //we erase the media from dataSource, form core data and then form the collection View
            let indicesToRemove = Set(selectedItemsIndex.map({$0.item}))
            mediaArray = folder.updatedMediaArray(mediaArray: mediaArray, indicesToRemove: indicesToRemove)
            //we have to set the cached attrubutes to empty so we can recalculate the layout
            let layout = collectionView.collectionViewLayout as! CustomLayout
            layout.cached = [UICollectionViewLayoutAttributes]()
            collectionView.deleteItems(at: selectedItemsIndex)
            layout.invalidateLayout()
            hideShowTheToolbar()
        }
    }
    
    @objc func hideShowTheToolbar(){
        //we change from .show to editing
        if controllerStatus == .show {
            navigationItemEdition.title = "Done"
            navigationItemEdition.setTitleTextAttributes(Constants.fontAttributes.navigationItem, for: .normal)
            controllerStatus = .editing
            collectionView.allowsMultipleSelection = true
            
            UIView.animate(withDuration: 0.5, animations: {
               self.trashButtonItem.isEnabled = true
               self.trashButtonItem.tintColor = Constants.colors.gold
            })
        }else{
            //we change from editing to show
            navigationItemEdition.title = "Select"
            navigationItemEdition.setTitleTextAttributes(Constants.fontAttributes.navigationItem, for: .normal)
            controllerStatus = .show
            collectionView.allowsMultipleSelection = false
            //we need to disable the trashbutton imediatly to prevent double clicks
            self.trashButtonItem.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.trashButtonItem.tintColor = .clear
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
        //we first remove the media
        let mediaToRemove = mediaArray.remove(at: sourceIndexPath.item)
        //then we change the index of the media
        mediaToRemove.index = Int64(destinationIndexPath.item)
        mediaArray.insert(mediaToRemove, at: destinationIndexPath.item)
        
        //we reassign all the indecees
        for (newIndex, media) in mediaArray.enumerated(){
            media.index = Int64(newIndex)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch controllerStatus{
        case .show:
            let media = folder.mediaArray()[indexPath.item]
            let controller = storyboard?.instantiateViewController(withIdentifier: "DetailPhoto") as! DetailViewController
            controller.media = media
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
        let number = mediaArray.count
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MediaCollectionViewCell
        let media = mediaArray[indexPath.item]
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
        //we get the unique string id for the media
        let uuidString = UUID().uuidString
        //we set the index of the media to be the last element
        let index = Int64(folder.folderToMedia.count - 1)
        // we did not set the allow editions so we are saving the original movie
        if mediaType == kUTTypeImage{
            let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            //if the image is not nil we save it to the folder
            if let originalImage = originalImage{
                print(originalImage.imageOrientation)
                guard let photoData = UIImageJPEGRepresentation(originalImage, 1) else { return }
                let stringMediaType = Constants.mediaType.photo
                createCoreMediaWithData(stringMediaType: stringMediaType, uuidString: uuidString, index: index, data: photoData)
            }
        }
        
        
       // this url is temp so it will be erased, we should then use the document for to save the url
        if let tempURL = info[UIImagePickerControllerMediaURL] as? URL{
            var videoData = Data()
            do{
                //we read the info from temp data to later write in a permanent data
                videoData = try Data(contentsOf: tempURL)
            }catch{
                print("unable to retrieive the data")
                return
            }
            let stringMediaType = Constants.mediaType.video
            createCoreMediaWithData(stringMediaType: stringMediaType, uuidString: uuidString, index: index, data: videoData)
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
    
    func createCoreMediaWithData(stringMediaType: String, uuidString: String, index: Int64, data: Data){
        guard let context = context else{return}
        let coreMedia = CoreMedia(stringMediaType: stringMediaType, uuidString: uuidString, index: index, folder: folder, context: context)
        mediaArray.append(coreMedia)
        let url = coreMedia.getURL()
        do{
            //we write data to the url
            try data.write(to: url, options: .atomic)
        }catch{
            print("there was an error to write to the url \(error)")
            context.delete(coreMedia)
        }
    }
}





