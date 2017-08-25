//
//  ImageCropper.swift
//  Zenyth
//
//  Created by Hoang on 8/24/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class ImageCropper: UIScrollView {
    
    var image: UIImage!
    var imageView: UIImageView!
    
    static let MIN_ZOOM_SCALE: CGFloat = 1.0
    static let MAX_ZOOM_SCALE: CGFloat = 10.0
    
    init(frame: CGRect, image: UIImage) {
        self.image = image
        super.init(frame: frame)
        
        self.minimumZoomScale = ImageCropper.MIN_ZOOM_SCALE
        self.maximumZoomScale = ImageCropper.MAX_ZOOM_SCALE
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        
        self.setupImageView(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupImageView(image: UIImage) {
        let imageSize = image.size
        let imageRatio = imageSize.width / imageSize.height
        
        // Scale the frame of image based on the ratio of the image
        if imageSize.width < imageSize.height { // portrait image
            let width = self.frame.width
            let height = self.frame.width / imageRatio
            let origin = CGPoint.zero
            let frame = CGRect(x: origin.x, y: origin.y,
                               width: width, height: height)
            imageView = UIImageView(frame: frame)
        }
        else { // landscape image
            let height = self.frame.height
            let width = self.frame.height * imageRatio
            let origin = CGPoint.zero
            let frame = CGRect(x: origin.x, y: origin.y,
                               width: width, height: height)
            imageView = UIImageView(frame: frame)
        }
        imageView.image = image
        self.addSubview(imageView)
        self.contentSize.height = imageView.frame.height
        self.contentSize.width = imageView.frame.width
    }
    
    func cropImage() -> UIImage {
        let cropArea = calculateCropArea()
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        return croppedImage
    }
    
    func calculateCropArea() -> CGRect {
        let scale = 1 / self.zoomScale
        
        let heightRatio = image.size.height / imageView.frame.height
        let widthRatio = image.size.width / imageView.frame.width
        
        // Calculate how much of the image view isn't shown in the scroll view
        var width = image.size.width * scale
        var height = image.size.height * scale
        width = width > height ? height : width
        height = width > height ? height : width
        
        let xOffset = self.contentOffset.x
        let yOffset = self.contentOffset.y
        
        // Calculate how much Y is lost
        let x = xOffset * widthRatio
        let y = yOffset * heightRatio
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
