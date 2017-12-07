//
//  CreateFileViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/26/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import CoreData

class CreateEditFolderViewController: UIViewController {
    
    var context: NSManagedObjectContext? = nil
    enum responsability{
        case create
        case edit
    }
    
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
        }
        createFolderButton.setTitle(buttonTitle, for: .normal)
        if let folder = folder {
            titleTextField.text = folder.title
            descriptionTextField.text = folder.folderDescription
            requirePasswordButton.isSelected = folder.secure
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
        }
        
        
        
    }
    
    @IBAction func requirePasswordWasPressed(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
    }
    
 
  
}
