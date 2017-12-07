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
   
    
    //MARK - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createFolder: UIButton!
    @IBOutlet weak var requirePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }
    
    @IBAction func createFolder(_ sender: Any){
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let stack = appDelegate.stack
       context = stack?.context
       let secure = requirePasswordButton.isSelected
       guard let context = context else{ return }
       let _ = CoreFolder(title: titleTextField.text!, folderDescription: descriptionTextField.text, notes: nil, secure:secure , context: context)
       stack?.saves()
       DispatchQueue.main.async{
           self.navigationController?.popViewController(animated: true)
       }
    }
    
    @IBAction func requirePasswordWasPressed(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
    }
    
 
  
}
