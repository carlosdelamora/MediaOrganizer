//
//  FolderCellTableViewCell.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/11/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class FolderCellTableViewCell: UITableViewCell {

    @IBOutlet weak var cellUIImageView: UIImageView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        cellUIImageView.image = nil
    }
    
    func configure(for folder: CoreFolder){
        //the first image in the folder
        cellUIImageView.layer.cornerRadius = cellUIImageView.frame.height*0.1
        cellUIImageView.clipsToBounds = true
      
       if folder.folderToMedia.count > 0{
            
            if let media = folder.mediaArray().first{
                cellUIImageView.placeSquareImageFromMedia(media: media, detail: false)
            }
        }else{
            cellUIImageView.image = UIImage(named:"logo")
        }
        titileLabel.text = folder.title.uppercased()
        descriptionLabel.text = folder.folderDescription
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

}
