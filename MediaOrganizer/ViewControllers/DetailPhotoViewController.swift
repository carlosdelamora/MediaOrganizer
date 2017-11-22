//
//  DetailPhotoViewController.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/22/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class DetailPhotoViewController: UIViewController{
    
    
    var media: Media!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = media.photo
        if let image = image{
            imageView.image = image
            //placePhoto(image: image)
            
        }
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
}

extension DetailPhotoViewController: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}







