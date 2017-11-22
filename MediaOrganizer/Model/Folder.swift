//
//  Folder.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/11/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit

class Folder: NSObject, NSCoding{
    
    //MARK -Properties
    var title:String //this title is unique and should be no nil
    var folderDescription: String?
    var notes:String?
    var mediaArray: [Media]
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let mediaUrl: URL?
    
    
    init(title: String, folderDescription: String?, notes: String? ){
        self.title = title
        self.mediaArray = [Media]()
        if let folderDescription = folderDescription{
            self.folderDescription = folderDescription
        }
        if let notes = notes{
            self.notes = notes
        }
        
        self.mediaUrl = documentsDirectory.appendingPathComponent(title)
        if let mediaUrl = self.mediaUrl{
            if let media = NSKeyedUnarchiver.unarchiveObject(withFile: mediaUrl.path) as? [Media]{
                self.mediaArray = media
            }
        }
    }
    
    //Protocol NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: Constants.FolderKeyProperties.title) as? String else{
            return nil
        }
        
        let folderDescription = aDecoder.decodeObject(forKey: Constants.FolderKeyProperties.folderDescription) as? String
        let notes = aDecoder.decodeObject(forKey: Constants.FolderKeyProperties.notes) as? String
        self.init(title: title, folderDescription: folderDescription, notes: notes)
    }
    
    //Protocol NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Constants.FolderKeyProperties.title)
        aCoder.encode(folderDescription, forKey: Constants.FolderKeyProperties.folderDescription)
        aCoder.encode(notes, forKey: Constants.FolderKeyProperties.notes)
    }

    
    func saveMedia(media:Media)-> Bool{
        var isSuccessfulSave = false
        if let mediaUrl = mediaUrl{
            //var newMediaArray = mediaArray
            //newMediaArray.append(media)
            //the mediaArray already contains the media element, because at the return of didfinishedpicking media with info we added the media to the media Array
            isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mediaArray, toFile: mediaUrl.path)
        }
        return isSuccessfulSave
    }
    
    func saveFolder()-> Bool{
        let foldersURL = documentsDirectory.appendingPathComponent(Constants.urlPaths.foldersPath)
        return NSKeyedArchiver.archiveRootObject(self, toFile: foldersURL.path)
    }
    
    /*func loadMedia(){
        if let mediaUrl = mediaUrl{
            if let media = NSKeyedUnarchiver.unarchiveObject(withFile: mediaUrl.path) as? [Media]{
                self.media = media
            }
        }
    }*/
    
}




