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
    var documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let mediaUrl: URL? //documents directory with the title extension
   // var videosDirectoryURL: URL?// we have the extension title + videos
    
    init(title: String, folderDescription: String?, notes: String? ){
        self.title = title
        self.mediaArray = [Media]()
        if let folderDescription = folderDescription{
            self.folderDescription = folderDescription
        }
        if let notes = notes{
            self.notes = notes
        }
        //we create media url
        self.mediaUrl = documentsDirectoryURL.appendingPathComponent(title)
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

    //we use this function to save media
    func saveMedia(media:Media)-> Bool{
        var isSuccessfulSave = false
        if let mediaUrl = mediaUrl{
            //var newMediaArray = mediaArray
            mediaArray.append(media)
            //the mediaArray already contains the media element, because at the return of didfinishedpicking media with info we added the media to the media Array
            isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mediaArray, toFile: mediaUrl.path)
        }
        return isSuccessfulSave
    }
    
    //we use this function to erase media
    func eraseMedia(indexesToRemove: Set<Int>){
        if let mediaUrl = mediaUrl {
            //we update the media array right away
            mediaArray = mediaArray.enumerated().filter({!indexesToRemove.contains($0.offset)}).map({$0.element})
            //we save the media in the background
            DispatchQueue.global().async {
                //we save the mediaArray with the media removed
                let _ = NSKeyedArchiver.archiveRootObject(self.mediaArray, toFile: mediaUrl.path)
            }
        }
        
    }
    
    //we use this function to save a reorder of the media
    func saveMediaChange(){
        if let mediaUrl = mediaUrl{
            let _ = NSKeyedArchiver.archiveRootObject(mediaArray, toFile: mediaUrl.path)
        }
    }
    
    func saveFolder()-> Bool{
        //the Constants.urlPaths.foldersPath = folders
        //TODO change the extension to depend on the name if the folder
        let foldersURL = documentsDirectoryURL.appendingPathComponent(Constants.urlPaths.foldersPath)
        
        return NSKeyedArchiver.archiveRootObject(self, toFile: foldersURL.path)
    }
    
    func createDirectoryInDocuments(){
        var isDirectory: ObjCBool = false
        let fileManager = FileManager.default
        let url = documentsDirectoryURL.appendingPathComponent(title + "videos")
        let absolutePath = url.absoluteString
        if fileManager.fileExists(atPath: absolutePath, isDirectory: &isDirectory){
            if isDirectory.boolValue{
                //file exists and is directory
            }else{
                //file does exits and is not directory
                print("this should not happen, the file should be a directory")
            }
           
        }else{
            //file does not exists we create a directory
            do{
                try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
                
            }catch{
                print("could not create a directory \(error.localizedDescription)")
            }
        }
    }
    
}




