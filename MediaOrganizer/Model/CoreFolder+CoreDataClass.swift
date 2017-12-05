//
//  CoreFolder+CoreDataClass.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/4/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreFolder)
public class CoreFolder: NSManagedObject {
    
    convenience init( title: String, folderDescription: String?, notes:String?,context: NSManagedObjectContext){
        
        if let entity = NSEntityDescription.entity(forEntityName: "CoreFolder", in: context){
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.folderDescription = folderDescription
            self.notes = notes
            self.folderToMedia = NSSet()
        }else{
            fatalError("there was an error with initalization")
        }
    }
    
    
    func mediaArray()->[CoreMedia]{
        let someOrderArray = Array(self.folderToMedia) as! [CoreMedia]
        let arrayOfMedia = someOrderArray.sorted(by: {$0.index < $1.index})
        return arrayOfMedia
    }
}
