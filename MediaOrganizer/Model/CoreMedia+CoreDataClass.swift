//
//  CoreMedia+CoreDataClass.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/4/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//
//

import Foundation
import CoreData


@objc(CoreMedia)
public class CoreMedia: NSManagedObject {
    
    var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    convenience init(stringMediaType:String, uuidString: String, index: Int64, folder: CoreFolder, context: NSManagedObjectContext){
        
        if let entity = NSEntityDescription.entity(forEntityName: "CoreMedia", in: context){
            self.init(entity: entity, insertInto: context)
            self.stringMediaType = stringMediaType
            self.uuidString = uuidString
            self.mediaToFolder = folder
            self.index = index
        }else{
            fatalError("there was an error in initalization")
        }
    }
    
    
    func getURL() -> URL{
        let pathExtension: String
        let mediaUrl:URL
        //if the uuidstring contains file it should be media importet from library in form of a phAsset
        if uuidString.range(of: "file") != nil{
            mediaUrl = URL(fileURLWithPath: uuidString)
        }else{
            if stringMediaType == Constants.mediaType.photo{
                pathExtension = "\(self.uuidString).jpg"
            }else{
                pathExtension = "\(self.uuidString).mov"
            }
            mediaUrl = documentURL.appendingPathComponent(pathExtension)
        }
        
        return mediaUrl
    }
    
}



