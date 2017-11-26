//
//  CreateFileViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/26/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class CreateFileViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createFolder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createFolder(_ sender: Any){
       let folder = Folder(title: titleTextField.text!, folderDescription: descriptionTextField.text, notes: nil)
        if folder.saveFolder(){
            print("folder has been created")
        }
        dismiss(animated: true, completion: nil)
        
    }
  
}
