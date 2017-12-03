//
//  CreateFileViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/26/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class CreateFileViewController: UIViewController {
    
    var documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var arrayOfFolders:[Folder] = [Folder]()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createFolder: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createFolder(_ sender: Any){
       let folder = Folder(title: titleTextField.text!, folderDescription: descriptionTextField.text, notes: nil)
        if saveFolder(folder: folder){
            print("folder has been created")
            folder.createDirectoryInDocuments()
        }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func saveFolder(folder: Folder)-> Bool{
        //the Constants.urlPaths.foldersPath = folders
        //TODO change the extension to depend on the name if the folder
        let foldersURL = documentsDirectoryURL.appendingPathComponent(Constants.urlPaths.foldersPath)
        arrayOfFolders.append(folder)
        return NSKeyedArchiver.archiveRootObject(arrayOfFolders, toFile: foldersURL.path)
    }
  
}
