//
//  ResuableCollectionViewCell.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/9/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit

class ReusableCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var folderNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        folderNameLabel.layer.cornerRadius = 3
        folderNameLabel.layer.borderColor = Constants.colors.gold.cgColor
        folderNameLabel.layer.borderWidth = 1
    }
}
