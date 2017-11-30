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
    var videoData: Data?
    
    init(stringMediaType:String, photo:UIImage?,videoURL: URL?, data: Data?){
        self.stringMediaType = stringMediaType
        self.photo = photo
        self.videoData = data
        if let data = data, let videoURL = videoURL{
            do{
              try data.write(to: videoURL, options: .atomic)
            }catch{
                print("error retriving data form url when instatate Media")
            }
        }
        self.videoURL = videoURL
    }
    
    //Protocol NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(stringMediaType, forKey: Constants.MediaKeyProperties.stringMediaType)
        aCoder.encode(photo, forKey: Constants.MediaKeyProperties.photo)
        aCoder.encode(videoURL, forKey: Constants.MediaKeyProperties.video)
        aCoder.encode(videoData, forKey: Constants.MediaKeyProperties.videoData)
    }
    
    //protocol NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let stringMediaType = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.stringMediaType) as? String else{
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.photo) as? UIImage
        let videoURL = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.video) as? URL
        let data = aDecoder.decodeObject(forKey: Constants.MediaKeyProperties.videoData) as? Data
        //since this is a convenient init we should call a designated init
        self.init(stringMediaType:stringMediaType, photo:photo,videoURL: videoURL, data: data)
    }
    
    
    
}
