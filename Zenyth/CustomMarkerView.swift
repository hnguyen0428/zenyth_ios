//
//  CustomMarkerView.swift
//  Zenyth
//
//  Created by Hoang on 9/1/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class CustomMarkerView: UIView {
    
    var image: Image?
    var imageView: UIImageView?
    
    static let BORDER_WIDTH: CGFloat = 3.0
    
    init(frame: CGRect, image: Image) {
        self.image = image
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        imageView = UIImageView(frame: frame)
        imageView!.layer.cornerRadius = frame.width/2
        imageView!.layer.borderColor = UIColor.white.cgColor
        imageView!.layer.borderWidth = CustomMarkerView.BORDER_WIDTH
        imageView!.clipsToBounds = true
        imageView!.contentMode = .scaleAspectFill
        imageView!.imageFromUrl(withUrl: image.getURL(size: "small"))
        imageView!.isUserInteractionEnabled = true
        
        self.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
