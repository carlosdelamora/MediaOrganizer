//
//  MediaCollectionViewCell.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/12/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit
import AVFoundation

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
   
    
    var selectedToErase: Bool = false {
        didSet{
            imageView.alpha = selectedToErase ? 0.25 : 1
        }
    }
    
    func configureForMedia(media:Media){
        if media.stringMediaType == Constants.mediaType.photo{
            if let photo = media.photo {
                imageView.image = squareImage(image: photo)
            }
        }else{
            guard let url = media.videoURL else{
                imageView.backgroundColor = .blue
                return
            }
            
            DispatchQueue.global().async {
                if let thumbnail = self.getThumbnailFrom(path: url){
                    DispatchQueue.main.async {
                        self.imageView.image = thumbnail
                        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                        let auxiliaryImageView = UIImageView(frame: frame)
                        auxiliaryImageView.image = UIImage(named: "playCircle")
                        auxiliaryImageView.tintColor = .white
                        self.imageView.addSubview(auxiliaryImageView)
                        auxiliaryImageView.translatesAutoresizingMaskIntoConstraints = false
                        self.imageView.centerXAnchor.constraint(equalTo: auxiliaryImageView.centerXAnchor).isActive = true
                        self.imageView.centerYAnchor.constraint(equalTo: auxiliaryImageView.centerYAnchor).isActive = true
                    }
                    
                }
            }
            
        }
    }
    //we made the image nil 
    override func prepareForReuse() {
        imageView.image = nil
        selectedToErase = false
    }
    
    
    
    func squareImage(image: UIImage) -> UIImage{
        
        let cgImage = image.cgImage!
        let squareheight:Int = min(cgImage.height, cgImage.width)
        let x = (cgImage.width - squareheight)/2
        let y = (cgImage.height - squareheight)/2
        let rect = CGRect(x: x, y: y, width: squareheight, height: squareheight)
        
        //we crop the image and make a new one
        let imageReferene = (image.cgImage?.cropping(to: rect))!
        let imageToReturn = UIImage(cgImage: imageReferene, scale: UIScreen.main.scale, orientation: image.imageOrientation)
        
        return imageToReturn
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = squareImage(image:UIImage(cgImage: cgImage))
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
    
    
    
}
