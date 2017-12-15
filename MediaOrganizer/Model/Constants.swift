//
//  Constants.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/20/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit

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
    
    struct colors{
        static let gold = UIColor(red: 1, green: 215/255, blue: 0/255, alpha: 1)
        static let purpleGray = UIColor(red: 45/255, green: 53/255, blue: 76/255, alpha: 1)
    }
    
    struct fontAttributes{
        static let navigationItem = [NSAttributedStringKey.font: UIFont(name:"Helvetica", size:20)!]
        static let americanTypewriter = [NSAttributedStringKey.font: UIFont(name:"AmericanTypewriter", size: 20)!]
    }
    
}
