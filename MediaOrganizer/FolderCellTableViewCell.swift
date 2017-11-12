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
        
    }
    
    func configure(for folder: Folder){
        //the first image in the folder
        if folder.photos.count > 0{
            cellUIImageView.image = folder.photos.first!
        }else{
            cellUIImageView.backgroundColor = .red
        }
        titileLabel.text = folder.title
        descriptionLabel.text = folder.description
    }

}
