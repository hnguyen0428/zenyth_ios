//
//  UIImageView+Extensions.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

typealias Handler = (Void) -> Void

extension UIImageView {
    
    func imageFromUrl(withUrl url: String, handler: DataCallback? = nil) {
        ImageManager().getImageData(withUrl: url,
                                    onSuccess:
            { data in
                self.image = UIImage(data: data)
                handler?(data)
        })
    }
    
    /**
     Method used to create a rounded image with a shadow
     - Parameters: Frame of the image
     - Returns: The container that contains the image
     */
    func roundedImageWithShadow(frame: CGRect) -> UIView {
        let container = UIView(frame: frame)
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds,
                                                  cornerRadius: frame.height/2).cgPath
        container.layer.shadowColor = UIColor.lightGray.cgColor
        container.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        container.layer.shadowRadius = 2.0
        container.layer.shadowOpacity = 0.5
        
        self.frame = container.bounds
        self.layer.cornerRadius = frame.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        
        self.backgroundColor = UIColor.clear
        container.addSubview(self)
        return container
    }
    
}
