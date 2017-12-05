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
import AVKit

class DetailViewController: UIViewController{
    
    
    var media: CoreMedia!
    //MARK: -Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.placeSquareImageFromMedia(media: media)
        switch media.stringMediaType{
        case Constants.mediaType.photo:
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 5.0
        case Constants.mediaType.video:
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playMovie))
            contentView.addGestureRecognizer(gestureRecognizer)
        default:
            print("this should not happen ")
            break
        }
    }
    
    @objc func playMovie(){
        let url = media.getURL()
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: url)
        playerViewController.player = player
        present(playerViewController, animated: true)
    }
    
}

extension DetailViewController: UIScrollViewDelegate{
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    

}







