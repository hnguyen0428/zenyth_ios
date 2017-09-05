//
//  ImagesScroller.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

/**
 The images scroller at the top of the expanded feed view
 */
class ImagesScroller: UIScrollView {
    
    var images: [Image] = [Image]()
    var currIndex = 0
    var numImageSet = 0
    var tg: UITapGestureRecognizer!
    
    weak var customDelegate: ImagesScrollerDelegate?
    
    init(frame: CGRect, images: [Image]) {
        super.init(frame: frame)
        self.backgroundColor = .black
        tg = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOnImage))
        
        for image in images {
            self.append(image: image)
            self.images.append(image)
        }
        
        self.addGestureRecognizer(tg)
    }
    
    /**
     Append an image to the scroller
     */
    func append(image: Image) {
        let frame = CGRect(x: self.frame.origin.x * CGFloat(numImageSet),
                           y: self.frame.origin.y,
                           width: self.frame.width,
                           height: self.frame.height)
        let imageView = UIImageView(frame: frame)
        imageView.backgroundColor = .black
        
        let url = URL(string: image.getURL(size: .large))
        imageView.sd_setImage(with: url)
        
        // Resize the content size so that you can scroll further
        self.contentSize.width += imageView.frame.width
        self.addSubview(imageView)
    }
    
    func didTappedOnImage(_ sender: UITapGestureRecognizer) {
        if images.count > 0 {
            let image = images[currIndex]
            customDelegate?.didTapped(on: image, sender: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        debugPrint("Deinitializing \(self)")
    }
}

protocol ImagesScrollerDelegate: class {
    func didTapped(on image: Image, sender: ImagesScroller)
}
