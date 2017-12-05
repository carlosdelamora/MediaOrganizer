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
    
    
    var media: CoreMedia!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO display the photo
        /*let image = media.photo
        if let image = image{
            imageView.image = image
            //placePhoto(image: image)
            
        }
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        //scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20)*/
    }
}

extension DetailPhotoViewController: UIScrollViewDelegate{
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    

}







