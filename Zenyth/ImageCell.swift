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
