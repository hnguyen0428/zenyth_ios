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
    
    weak var imageView: UIImageView?
    
    override var isSelected: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(frame: frame)
        self.imageView = imageView
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
    }
    
    func setImage(image: UIImage) {
        self.imageView?.image = image
    }
    
    func turnonShade() {
        self.imageView?.alpha = 0.5
    }
    
    func turnoffShade() {
        self.imageView?.alpha = 1.0
    }
    
    func onSelected(_ newValue: Bool) {
        if newValue {
            turnonShade()
        }
        else {
            turnoffShade()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
