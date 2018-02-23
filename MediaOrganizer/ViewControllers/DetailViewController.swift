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
import Photos

class DetailViewController: UIViewController{
    
    
    var media: CoreMedia!
    var shareMedia = UIBarButtonItem()
    //MARK: -Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create an item to share the media
        shareMedia = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentActionController))
        navigationItem.rightBarButtonItem = shareMedia
        
        imageView.placeSquareImageFromMedia(media: media,detail: true)
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
    
    @objc func presentActionController(){
        
        switch media.stringMediaType{
        case Constants.mediaType.photo:
            guard let image = imageView.image else{return}
            presentActivityController(items: [image])
        case Constants.mediaType.video:
            if media.isPhAsset{
                guard let phAsset = media.getPhAsset() else{ return }
                PHImageManager.default().requestPlayerItem(forVideo: phAsset, options: nil, resultHandler: { playerItem, info in
                    if let playerAsset = playerItem?.asset as? AVURLAsset{
                        
                        let url = playerAsset.url
                        var videoData = Data()
                        var tempURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        tempURL.appendPathComponent("temp.mov")
                        do{
                            videoData = try Data(contentsOf: url)
                        }catch{
                            print("error with the video data \(error)")
                        }
                        
                        do{
                            try videoData.write(to: tempURL)
                        }catch{
                            print("could not write to tempURL\(error)")
                        }

                        self.presentActivityController(items: [tempURL])
                    }
                })
            }else{
                let mediaUrl = media.getURL()
                presentActivityController(items: [mediaUrl])
            }
        default:
            print("this should not happen ")
            break
        }
    }
    
    func presentActivityController(items: [Any]){
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.barButtonItem = shareMedia
        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }
    }
    
    @objc func playMovie(){
        let playerViewController = AVPlayerViewController()
        var player: AVPlayer
        if media.isPhAsset{
           guard let phAsset = media.getPhAsset() else{ return }
           PHImageManager.default().requestPlayerItem(forVideo: phAsset, options: nil, resultHandler: { playerItem, info in
               let player = AVPlayer(playerItem: playerItem)
               playerViewController.player = player
            
           })
        }else{
            let url = media.getURL()
            player = AVPlayer(url: url)
            playerViewController.player = player
        }
        
        present(playerViewController, animated: true)
    }
    
}

extension DetailViewController: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    

}







