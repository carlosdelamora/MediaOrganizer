//
//  CoreMedia+CoreDataProperties.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/4/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreMedia> {
        return NSFetchRequest<CoreMedia>(entityName: "CoreMedia")
    }

    @NSManaged public var stringMediaType: String
    @NSManaged public var uuidString: String
    @NSManaged public var index: Int64
    @NSManaged public var mediaToFolder: CoreFolder?

}
