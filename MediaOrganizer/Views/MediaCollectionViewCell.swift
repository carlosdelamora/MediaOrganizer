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
                imageView.image = squareImage(image: photo)
            }
        }else{
            imageView.backgroundColor = .blue
        }
    }
    
    func squareImage(image: UIImage) -> UIImage{
        
        let cgImage = image.cgImage!
        let squareheight:Int = min(cgImage.height, cgImage.width)
        let x = (cgImage.width - squareheight)/2
        let y = (cgImage.height - squareheight)/2
        let rect = CGRect(x: x, y: y, width: squareheight, height: squareheight)
        
        //we crop the image and make a new one
        var imageReferene = (image.cgImage?.cropping(to: rect))!
        let imageToReturn = UIImage(cgImage: imageReferene, scale: UIScreen.main.scale, orientation: image.imageOrientation)
        
        return imageToReturn
    }
    
    
}
