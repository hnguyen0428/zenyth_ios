//
//  ImageViewController.swift
//  Zenyth
//
//  Created by Hoang on 9/1/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var image: Image!
    var imageViewer: ImageViewer!
    var pg: UIPanGestureRecognizer!
    
    weak var delegate: ImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupPanGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    func setupViews() {
        self.view.backgroundColor = .black
    
        let frame = self.view.frame
        imageViewer = ImageViewer(frame: frame, image: self.image)
        imageViewer.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(imageViewer)
    }
    
    func setupPanGesture() {
        pg = UIPanGestureRecognizer(target: self, action: #selector(didLongSwipeVertically))
        imageViewer.addGestureRecognizer(pg)
    }
    
    func didLongSwipeVertically(_ pg: UIPanGestureRecognizer) {
        if imageViewer.zoomScale == imageViewer.minimumZoomScale {
            let translation = pg.translation(in: imageViewer)
            
            if abs(translation.y) > imageViewer.frame.height / 5 {
                delegate?.didLongSwipeVertically(sender: self)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewer.view
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == scrollView.minimumZoomScale {
            imageViewer.addGestureRecognizer(pg)
        }
        else {
            imageViewer.removeGestureRecognizer(pg)
        }
    }
    
    func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            if let image = imageViewer.imageView.image {
                let ratio = image.size.width / image.size.height
                let height = self.view.frame.height
                let width = height * ratio
                imageViewer.imageView.frame.size = CGSize(width: width, height: height)
                imageViewer.frame = self.view.frame
                imageViewer.view.frame = imageViewer.frame
                imageViewer.imageView.center = imageViewer.center
            }
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            if let image = imageViewer.imageView.image {
                let ratio = image.size.height / image.size.width
                let width = self.view.frame.width
                let height = width * ratio
                imageViewer.imageView.frame.size = CGSize(width: width, height: height)
                imageViewer.frame = self.view.frame
                imageViewer.view.frame = imageViewer.frame
                imageViewer.imageView.center = imageViewer.center
            }
        }
        
    }
    
}
