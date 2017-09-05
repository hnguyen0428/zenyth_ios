//
//  ImageViewer.swift
//  Zenyth
//
//  Created by Hoang on 9/1/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class ImageViewer: UIScrollView {
    
    var image: Image?
    var view: UIView?
    var imageView: UIImageView?
    
    static let MIN_ZOOM_SCALE: CGFloat = 1.0
    static let MAX_ZOOM_SCALE: CGFloat = 10.0
    
    init(frame: CGRect, image: Image) {
        self.image = image
        
        super.init(frame: frame)
        
        self.backgroundColor = .black
        self.minimumZoomScale = ImageViewer.MIN_ZOOM_SCALE
        self.maximumZoomScale = ImageViewer.MAX_ZOOM_SCALE
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        view = UIView(frame: self.frame)
        view!.backgroundColor = self.backgroundColor
        self.addSubview(view!)
        
        imageView = UIImageView()
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        view!.addSubview(imageView!)
        loadImage()
        
        self.contentSize = self.frame.size
        
    }
    
    func loadImage() {
        ImageManager().getImageData(withUrl: image!.url, onSuccess:
            { data in
                if let uiimage = UIImage(data: data) {
                    let ratio = uiimage.size.height / uiimage.size.width
                    let width = self.frame.width
                    let height = width * ratio
                    self.imageView!.frame.size = CGSize(width: width, height: height)
                    self.imageView!.center = self.center
                    self.imageView!.image = uiimage
                }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
