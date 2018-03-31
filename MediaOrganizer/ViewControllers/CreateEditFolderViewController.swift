//
//  CreateFileViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/26/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import CoreData
import Photos

class CreateEditFolderViewController: UIViewController {
    
    var context: NSManagedObjectContext? = nil
    enum responsability{
        case create
        case edit
        case importAssetCollection
    }
    
    var assetCollection: PHAssetCollection?
    var folder: CoreFolder?
    var typeOfResponsability: responsability = .create
    
    //MARK - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createFolderButton: UIButton!
    @IBOutlet weak var requirePasswordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK- ViewController Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        //insertgradient in the back
        //let gradient = GradientView(frame: view.frame)
        //view.insertSubview(gradient, at: 0)
        //style the buttons
        createFolderButton.layer.cornerRadius = 5
        createFolderButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 5
        deleteButton.clipsToBounds = true 
        
        //set the delegates of the text fields
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        
        var buttonTitle: String
        switch typeOfResponsability{
        case .create:
            buttonTitle = "Create"
            deleteButton.isHidden = true
        case .edit:
            buttonTitle = "Save Edit"
            deleteButton.isHidden = false
        case .importAssetCollection:
            buttonTitle = "Import Media"
            deleteButton.isHidden = true
        }
        
        createFolderButton.setTitle(buttonTitle, for: .normal)
        //if we are in edit folder we set the values for textFields to the current folder
        if let folder = folder {
            titleTextField.text = folder.title
            descriptionTextField.text = folder.folderDescription
            requirePasswordButton.isSelected = folder.secure
        }
        //if we want to import the album we use the title of the album in the text field
        if let assetCollection = assetCollection, let localizedTitle =  assetCollection.localizedTitle{
            titleTextField.text = localizedTitle
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        //get the context to save in core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stack = appDelegate.stack
        context = stack?.context
        //we see if the folder is no nil
        if let folder = folder {
            //we first erase the data save in the url in documents directory they we erase the folder
            DispatchQueue.global().async {
                let fileManager = FileManager.default
                folder.mediaArray().forEach{ media in
                    if !media.isPhAsset{
                        do{
                            try fileManager.removeItem(at: media.getURL())
                        }catch{
                            print("there was an error deleting \(error.localizedDescription)")
                        }
                    }
                }
                
                self.context?.perform {
                    self.context?.delete(folder)
                }
                
                //we dispatch main to return
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
    }
        
    
    
    
    @IBAction func createFolder(_ sender: Any){
        
        //get the context to save in core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stack = appDelegate.stack
        context = stack?.context
        guard let context = context else{ return }
        //info entered by the user to determine the security of the folder
        let secure = requirePasswordButton.isSelected
        
        switch  typeOfResponsability{
        case .create://we create a new folder
            let _ = CoreFolder(title: titleTextField.text!, folderDescription: descriptionTextField.text, notes: nil, secure:secure , context: context)
            stack?.saves()
            DispatchQueue.main.async{
                self.navigationController?.popViewController(animated: true)
            }
        case .edit:
            guard let folder = folder else {return}
            folder.title = titleTextField.text!
            folder.folderDescription = descriptionTextField.text!
            folder.secure = secure
            stack?.saves()
            DispatchQueue.main.async{
                self.navigationController?.popViewController(animated: true)
            }
        case .importAssetCollection:
            importMediaFromAssetCollection(title: titleTextField.text!, folderDescription: descriptionTextField.text, notes: nil, secure:secure , context: context)
            DispatchQueue.main.async{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func requirePasswordWasPressed(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    func importMediaFromAssetCollection(title: String, folderDescription: String?, notes: String?, secure: Bool, context: NSManagedObjectContext){
        guard let assetCollection = assetCollection else {return}
        
        //We create a folder and then create the media in this folder
        let folder = CoreFolder(title: title, folderDescription: folderDescription, notes: notes, secure: secure, context: context)
        //we fetch all the PHAssets from collection that are video of photo
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let phAssets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
       
       
        //we get the for each phAsset object a medaia
        for index in 0..<phAssets.count{
            let phAsset = phAssets[index]
            phAsset.containsThumbnail{ containsTumbnail in
                
                if containsTumbnail{
                    switch phAsset.mediaType{
                    case .image:
                        let _ = CoreMedia(stringMediaType: Constants.mediaType.photo, uuidString: phAsset.localIdentifier, index: Int64(index), folder: folder,isPhAsset: true, context: context)
                    case .video:
                        let _ = CoreMedia(stringMediaType: Constants.mediaType.video, uuidString: phAsset.localIdentifier, index: Int64(index), folder: folder, isPhAsset: true, context: context)
                    default:
                        break
                    }
                }
            }
        }
    }
}

extension CreateEditFolderViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput?.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    func containsThumbnail(completion:@escaping (Bool) -> Void){
        //we first fetch the phAsset
        
    
        let requestOptions = PHImageRequestOptions()
        requestOptions.version = .original
        requestOptions.deliveryMode = .highQualityFormat
        let cachingManager = PHCachingImageManager()
        cachingManager.allowsCachingHighQualityImages = true
        cachingManager.requestImage(for: self, targetSize: CGSize(width:100,height:100), contentMode: .aspectFit, options: requestOptions, resultHandler:{ thumbnail, info in
            
            DispatchQueue.main.async {
                if let _ = thumbnail{
                    
                    completion(true)
                }else{
                    print("there was an error with the phAsset image erase media)")
                    completion(false)
                }
            }
            
        })
        
    }
    
    
    
}
