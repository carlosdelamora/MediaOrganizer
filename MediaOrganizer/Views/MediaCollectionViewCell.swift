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
    
    func configureForMedia(media:CoreMedia){
        imageView.placeSquareImageFromMedia(media: media)
    }
    //we made the image nil 
    override func prepareForReuse() {
        self.isSelected = false
        imageView.image = nil
        selectedToErase = false
        if let auxiliaryView = imageView.viewWithTag(100){
            auxiliaryView.removeFromSuperview()
        }
    }
    
    
    
    
}


extension UIImageView{
    
    func placeSquareImageFromMedia(media: CoreMedia){
        var auxiliaryImageView: UIImageView? = nil
        
        //we can not add an auxiliaryViewMore than once
        if let anotherAuxiliaryView = self.viewWithTag(100){
           anotherAuxiliaryView.removeFromSuperview()
        }
        let url = media.getURL()
        switch media.stringMediaType{
        case Constants.mediaType.photo:
            if let photoData = try? Data(contentsOf: url), let photo = UIImage(data:photoData){
                self.image = squareImage(image: photo)
                auxiliaryImageView?.image = nil
                auxiliaryImageView = nil
            }
        case Constants.mediaType.video:
            //we place a video image in top of the thumbnail
            if let thumbnail = self.getThumbnailFrom(path: url){
                DispatchQueue.main.async {
                    self.image = thumbnail
                    let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    auxiliaryImageView = UIImageView(frame: frame)
                    auxiliaryImageView?.tag = 100
                    guard let auxiliaryImageView = auxiliaryImageView else{
                        return
                    }
                    auxiliaryImageView.image = UIImage(named: "PlayCircle")
                    auxiliaryImageView.tintColor = .white
                    self.addSubview(auxiliaryImageView)
                    auxiliaryImageView.translatesAutoresizingMaskIntoConstraints = false
                    auxiliaryImageView.heightAnchor.constraint(equalTo: auxiliaryImageView.widthAnchor, multiplier: 1).isActive = true
                    auxiliaryImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.10, constant: 20).isActive = true
                    self.centerXAnchor.constraint(equalTo: auxiliaryImageView.centerXAnchor).isActive = true
                    self.centerYAnchor.constraint(equalTo: auxiliaryImageView.centerYAnchor).isActive = true
                }
            }
        default:
            print("there was an error presenting the image from core Media")
        }
    }
    
    //return a square image out of an image
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
    
    //we get an image form the video
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

