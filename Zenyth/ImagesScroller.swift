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
    
    var imageViews: [UIImageView] = [UIImageView]()
    var currIndex = 0
    var numImageSet = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupImageView() {
        let frame = self.frame
        
        // This is the first image view, always available no matter what
        let imageView = UIImageView(frame: frame)
        imageView.backgroundColor = .black
        self.imageViews.append(imageView)
        self.addSubview(imageView)
        
        // Setting the content size in order for the scroll view to know how much
        // it can scroll to
        self.contentSize.width = imageView.frame.width
        self.contentSize.height = imageView.frame.height
    }
    
    /**
     Append an image to the scroller
     */
    func append(image: UIImage) {
        if numImageSet == 0 {
            if let imageView = imageViews.first {
                imageView.image = image
                numImageSet += 1
            }
        }
        else {
            let frame = CGRect(x: self.frame.origin.x * CGFloat(numImageSet),
                               y: self.frame.origin.y,
                               width: self.frame.width,
                               height: self.frame.height)
            let imageView = UIImageView(frame: frame)
            imageView.image = image
            imageViews.append(imageView)
            
            // Resize the content size so that you can scroll further
            self.contentSize.width += imageView.frame.width
        }
    }
}
