//
//  Constants.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/20/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation

struct Constants {
    
    
    struct mediaType{
        static let video: String = "video"
        static let photo: String = "photo"
    }
    
    struct MediaKeyProperties{
        static let stringMediaType = "stringMediaType"
        static let video = "video"
        static let photo = "photo"
    }
    
    struct FolderKeyProperties{
        static let title = "title" //this title is unique and should be no nil
        static let folderDescription = "folderDescription"
        static let notes = "notes"
        static let media = "media"
    }
    
    struct urlPaths{
        static let mediaPath = "media"
        static let foldersPath = "folders"
    }
}
