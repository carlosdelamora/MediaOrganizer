//
//  Media.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/20/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit

class Media: NSObject, NSCoding{
    

    var stringMediaType: String //video or photo
    var photo: UIImage?
    var videoURL: URL?
    
    init(stringMediaType:String, photo:UIImage?,videoURL: URL?){
        self.stringMediaType = stringMediaType
        self.photo = photo
        self.videoURL = videoURL
    }
    
    //Protocol NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(stringMediaType, forKey: Constants.MediaKeyProperties.stringMediaType)
        aCoder.encode(photo, forKey: Constants.MediaKeyProperties.photo)
        aCoder.encode(videoURL, forKey: Constants.MediaKeyProperties.video)
    }
    
    //protocol NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let stringMediaType = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.stringMediaType) as? String else{
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.photo) as? UIImage
        let videoURL = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.video) as? URL
        //since this is a convenient init we should call a designated init
        self.init(stringMediaType:stringMediaType, photo:photo,videoURL: videoURL)
    }
    
    
    
}
