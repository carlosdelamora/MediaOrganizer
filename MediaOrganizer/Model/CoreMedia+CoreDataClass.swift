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
    
    convenience init(stringMediaType:String, uuidString: String, folder: CoreFolder, context: NSManagedObjectContext){
        
        if let entity = NSEntityDescription.entity(forEntityName: "CoreMedia", in: context){
            self.init(entity: entity, insertInto: context)
            self.stringMediaType = stringMediaType
            self.uuidString = uuidString
            self.mediaToFolder = folder
        }else{
            fatalError("there was an error in initalization")
        }
    }
}
