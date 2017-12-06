//
//  CoreFolder+CoreDataProperties.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/5/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreFolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreFolder> {
        return NSFetchRequest<CoreFolder>(entityName: "CoreFolder")
    }

    @NSManaged public var folderDescription: String?
    @NSManaged public var notes: String?
    @NSManaged public var title: String
    @NSManaged public var secure: Bool
    @NSManaged public var folderToMedia: NSSet

}

// MARK: Generated accessors for folderToMedia
extension CoreFolder {

    @objc(addFolderToMediaObject:)
    @NSManaged public func addToFolderToMedia(_ value: CoreMedia)

    @objc(removeFolderToMediaObject:)
    @NSManaged public func removeFromFolderToMedia(_ value: CoreMedia)

    @objc(addFolderToMedia:)
    @NSManaged public func addToFolderToMedia(_ values: NSSet)

    @objc(removeFolderToMedia:)
    @NSManaged public func removeFromFolderToMedia(_ values: NSSet)

}
