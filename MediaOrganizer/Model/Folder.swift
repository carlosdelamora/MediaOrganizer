//
//  Folder.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/11/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit

class Folder{
    
    var title:String //this title is unique and should be no nil
    var description: String?
    var notes:String?
    var media: [Media]
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let mediaUrl: URL?
    
    
    init(title: String){
        self.title = title
        self.media = [Media]()
        self.mediaUrl = documentsDirectory.appendingPathComponent(title)
    }
    
    
    func saveMedia(media:Media)-> Bool{
        
        var isSuccessfulSave = false
        if let mediaUrl = mediaUrl{
            isSuccessfulSave = NSKeyedArchiver.archiveRootObject(media, toFile: mediaUrl.path)
        }
        
        
        return isSuccessfulSave
    }
    
    func loadMedia(){
        if let mediaUrl = mediaUrl{
            if let media = NSKeyedUnarchiver.unarchiveObject(withFile: mediaUrl.path) as? [Media]{
                self.media = media
            }
        }
    }
    
}
