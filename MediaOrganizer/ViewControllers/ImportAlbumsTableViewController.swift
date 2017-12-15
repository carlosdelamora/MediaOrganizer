//
//  ImportAlbumsTableViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/7/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import Photos

class ImportAlbumsTableViewController: UITableViewController {
    
    var albums =  PHFetchResult<PHAssetCollection>()
    var smartAlbums = PHFetchResult<PHAssetCollection>()
    var totalNumber: Int = 0 {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        totalNumber = albums.count + smartAlbums.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalNumber
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let assetCollection = getAssetCollectionForIndexPath(indexPath: indexPath)
        cell.textLabel?.text = assetCollection.localizedTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assetCollection = getAssetCollectionForIndexPath(indexPath: indexPath)
        let createEditFolderController = storyboard?.instantiateViewController(withIdentifier: "createFolder") as! CreateEditFolderViewController
        createEditFolderController.typeOfResponsability = .importAssetCollection
        createEditFolderController.assetCollection = assetCollection
        navigationController?.pushViewController(createEditFolderController, animated: true)
    }
    
    private func getAssetCollectionForIndexPath(indexPath: IndexPath)-> PHAssetCollection{
        var assetCollection: PHAssetCollection
        if indexPath.row < albums.count {
            assetCollection = albums[indexPath.item]
        }else{
            assetCollection = smartAlbums[indexPath.item - albums.count]
        }
        return assetCollection
    }

}
