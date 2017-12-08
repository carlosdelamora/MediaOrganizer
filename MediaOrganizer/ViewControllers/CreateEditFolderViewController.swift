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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var buttonTitle: String
        switch typeOfResponsability{
        case .create:
            buttonTitle = "Create"
        case .edit:
            buttonTitle = "Save Edit"
        case .importAssetCollection:
            buttonTitle = "Import Media"
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
        }
    }
    
    @IBAction func requirePasswordWasPressed(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    func importMediaFromAssetCollection(title: String, folderDescription: String?, notes: String?, secure: Bool, context: NSManagedObjectContext){
        guard let assetCollection = assetCollection else {return}
        
        //We create a folder and then create the media in this folder
        //let folder = CoreFolder(title: title, folderDescription: folderDescription, notes: notes, secure: secure, context: context)
        //we fetch all the PHAssets from collection that are video of photo
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let phAssets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
        //we get the for each phAsset object a medaia
        for index in 0..<phAssets.count{
            let url = phAssets[index].getURL(completionHandler: { url in
               
                if let url = url{
                    let urlAbsoluteString = url.absoluteString
                }
                
            })
        }
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
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
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
}
