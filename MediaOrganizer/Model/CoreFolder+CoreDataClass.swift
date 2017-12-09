import Foundation
import CoreData
import UIKit

@objc(CoreFolder)
public class CoreFolder: NSManagedObject {
    
    var context: NSManagedObjectContext? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    convenience init( title: String, folderDescription: String?, notes:String?, secure: Bool,context: NSManagedObjectContext){
        
        if let entity = NSEntityDescription.entity(forEntityName: "CoreFolder", in: context){
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.folderDescription = folderDescription
            self.notes = notes
            self.folderToMedia = NSSet()
            self.secure = secure
        }else{
            fatalError("there was an error with initalization")
        }
    }
    
    
    func mediaArray()->[CoreMedia]{
        let someOrderArray = Array(self.folderToMedia) as! [CoreMedia]
        let arrayOfMedia = someOrderArray.sorted(by: {$0.index < $1.index})
        //we reassign all the indecees to make sure we have different consecutive indecees
        for (newIndex, media) in arrayOfMedia.enumerated(){
            media.index = Int64(newIndex)
        }
        return arrayOfMedia
    }
    
    func updatedMediaArray(mediaArray: [CoreMedia], indicesToRemove:Set<Int>)-> [CoreMedia]{
        
        let stack = appDelegate.stack
        context = stack?.context
        let fileManager = FileManager.default
        
        let filteredArray = mediaArray.filter({ !indicesToRemove.contains(Int($0.index))})
        let mediaToErase = mediaArray.filter({indicesToRemove.contains(Int($0.index))})
        DispatchQueue.global().async {
            for media in mediaToErase{
                //the context should not be nil, otherwise we do not erase anything
                guard let context = self.context else {return}
                context.perform {
                    self.context?.delete(media)
                }
                do{
                    try fileManager.removeItem(at: media.getURL())
                }catch{
                    print("there was an error deleting \(error.localizedDescription)")
                }
            }
        }
        
        //we reassign all the indecees
        for (newIndex, media) in filteredArray.enumerated(){
            media.index = Int64(newIndex)
        }
        return filteredArray
    }
    
}

