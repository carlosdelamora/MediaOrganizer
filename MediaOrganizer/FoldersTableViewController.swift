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
    var arrayOfFolders = [Folder]()
    var matchingFolders = [Folder]()
    //MARK: IBOultes
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foldersTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let folder1 = Folder(title: "first", description: "not good", notes:"some notes" , photos: [], videos: [URL]())
        let folder2 = Folder(title: "second", description: "not good", notes:"some notes" , photos: [UIImage](), videos: [URL]())
        arrayOfFolders.insert(folder1, at: 0)
        arrayOfFolders.insert(folder2, at: 1)
        //the matching folders will be the arrayOfFolders initialy
        matchingFolders = arrayOfFolders
        
        //we set the delegate of the table view
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        searchBar.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}

extension FoldersTableViewController: UITableViewDelegate{
    
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










