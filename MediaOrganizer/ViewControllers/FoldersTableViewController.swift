//
//  FoldersTableViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/11/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData

class FoldersTableViewController: UIViewController {
    
    var context: NSManagedObjectContext? = nil
    var lockButton:UIButton!
    let cellId = "FolderCell"
    var arrayOfFolders = [CoreFolder]()
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var matchingFolders = [CoreFolder]()
    var isLocked:Bool = true
    //MARK: IBOultes
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foldersTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the context for core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stack = appDelegate.stack
        context = stack?.context
        
        // Add a bar button item
        let createFolderItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateFolder))
        navigationItem.rightBarButtonItem = createFolderItem
        
        lockButton = UIButton(type: .custom)
        lockButton.isSelected = false
        lockButton.setImage(UIImage(named:"unlock"), for: .selected)
        lockButton.setImage(UIImage(named:"lock"), for: .normal)
        lockButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        lockButton.tintColor = lockButton.isSelected ? self.view.tintColor : Constants.colors.gold
        lockButton.addTarget(self, action: #selector(lockOrUnlock), for: .touchUpInside)
        let lockButtonItem = UIBarButtonItem(customView: lockButton)
        navigationItem.leftBarButtonItem = lockButtonItem
        
        //we set the delegate of the table view
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        searchBar.delegate = self
        foldersTableView.allowsSelection = true 
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(gestureRecognizer)
        
        loadArrayOfFolders()
        matchingFolders = arrayOfFolders.sorted(by: { $0.title < $1.title })
        //since the matching folders is what we use for the arrayOfFolders we should relaod the data after this
        DispatchQueue.main.async {
            self.foldersTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArrayOfFolders()
        //since the matching folders is what we use for the arrayOfFolders we should relaod the data after this
    }
    
    //we use the viewDid appear because it fires after saving the folder, in case we save a folder while changing the notes
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //the matching folders will be the arrayOfFolders initialy
        //then matching folders only shows the filtered folders
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func lockOrUnlock(){
        //if is selected that means that is unlocked and whants to lock it
        if lockButton.isSelected {
            lockButton.isSelected = !lockButton.isSelected
            lockButton.tintColor = lockButton.isSelected ? self.view.tintColor : Constants.colors.gold
        }else{
            let myContext = LAContext()
            let myLocalizedReasonString = "We need to identify you"
            myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    // User authenticated successfully, take appropriate action
                    print("success in print password")
                    DispatchQueue.main.async {
                        self.lockButton.isSelected = !self.lockButton.isSelected
                        self.lockButton.tintColor = self.lockButton.isSelected ? self.view.tintColor : Constants.colors.gold
                    }
                    
                }else{
                    print("fail in print password")
                }
            }
        }
    }
    
    func loadArrayOfFolders(){
        /*let foldersURL = documentsDirectory.appendingPathComponent(Constants.urlPaths.foldersPath)
        let folders = NSKeyedUnarchiver.unarchiveObject(withFile: foldersURL.path) as? [Folder]
        if let folders = folders{
            arrayOfFolders = folders
        }*/
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreFolder")
        let predicate:NSPredicate? = nil
        fetchRequest.predicate = predicate
        context?.perform {
            do{
                if let results = try self.context?.fetch(fetchRequest) as? [CoreFolder]{
                    self.arrayOfFolders = results
                    self.matchingFolders = self.arrayOfFolders.sorted(by: { $0.title < $1.title })
                    DispatchQueue.main.async {
                        self.foldersTableView.reloadData()
                    }
                }
            }catch{
                print("there was an error in fetching the core folders \(error.localizedDescription)")
            }
        }
    }
    
    @objc func goToCreateFolder(){
        let createFolderController = storyboard?.instantiateViewController(withIdentifier: "createFolder") as! CreateFileViewController
        //createFolderController.arrayOfFolders = arrayOfFolders
        navigationController?.pushViewController(createFolderController, animated: true)
    }

}

extension FoldersTableViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let folder = matchingFolders[indexPath.row]
        let collectionViewController = storyboard?.instantiateViewController(withIdentifier: "CollectionView") as! CollectionViewController
        collectionViewController.folder = folder
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
    
}

extension FoldersTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingFolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCellTableViewCell
        let folder = matchingFolders[indexPath.row]
        cell.configure(for: folder)
        return cell
        
    }
}

extension FoldersTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            matchingFolders = arrayOfFolders
        }else{
        matchingFolders = arrayOfFolders.filter({folderContainsText(searchText: searchText, folder: $0)})
        }
        foldersTableView.reloadData()
    }
    
    
    func folderContainsText(searchText:String,folder: CoreFolder )-> Bool{
        let folderText = folder.title + " " + (folder.folderDescription ?? "")
        return folderText.lowercased().range(of: searchText.lowercased()) != nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}










