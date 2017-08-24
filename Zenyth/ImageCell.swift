//
//  ImageCell.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let width = frame.width * 0.99
//        let height = frame.height * 0.99
//        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        self.imageView = UIImageView(frame: frame)
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
