//
//  MediaCollectionViewCell.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/12/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
   
    
    func configureForMedia(media:Media){
        if media.stringMediaType == Constants.mediaType.photo{
            if let photo = media.photo {
                imageView.image = photo
            }
        }else{
            imageView.backgroundColor = .blue
        }
    }
    
    
}
