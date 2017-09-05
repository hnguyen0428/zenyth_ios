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
    weak var imageView: UIImageView?
    
    static let BORDER_WIDTH: CGFloat = 3.0
    
    init(frame: CGRect, image: Image) {
        self.image = image
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        let imageView = UIImageView(frame: frame)
        self.imageView = imageView
        imageView.layer.cornerRadius = frame.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = CustomMarkerView.BORDER_WIDTH
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let url = URL(string: image.getURL(size: .small))
        imageView.sd_setImage(with: url)
        imageView.isUserInteractionEnabled = true
        
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
