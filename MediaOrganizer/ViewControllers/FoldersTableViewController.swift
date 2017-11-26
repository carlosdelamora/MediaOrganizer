//
//  FoldersTableViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/11/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class FoldersTableViewController: UIViewController {
    
    let cellId = "FolderCell"
    var arrayOfFolders = [Folder](){
        didSet{
            foldersTableView.reloadData()
        }
    }
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    var matchingFolders = [Folder]()
    //MARK: IBOultes
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foldersTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a bar button item
        let createFolderItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateFolder))
        navigationItem.rightBarButtonItem = createFolderItem
        
        
        //we set the delegate of the table view
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        searchBar.delegate = self
        foldersTableView.allowsSelection = true 
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //the matching folders will be the arrayOfFolders initialy
        //then matching folders only shows the filtered folders
        loadArrayOfFolders()
        matchingFolders = arrayOfFolders
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func loadArrayOfFolders(){
        let foldersURL = documentsDirectory.appendingPathComponent(Constants.urlPaths.foldersPath)
        let folders = NSKeyedUnarchiver.unarchiveObject(withFile: foldersURL.path) as? Folder
        if let folders = folders{
            arrayOfFolders = [folders]
        }
    }
    
    @objc func goToCreateFolder(){
        let createFolderController = storyboard?.instantiateViewController(withIdentifier: "createFolder") as! CreateFileViewController
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
    
    
    func folderContainsText(searchText:String,folder: Folder )-> Bool{
        
        let folderText = folder.title + " " + (folder.description ?? "")
        
        return folderText.lowercased().range(of: searchText.lowercased()) != nil
    }
    
}










