//
//  CustomReusableView.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/15/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class CustomReusableView: UICollectionReusableView {
    
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
