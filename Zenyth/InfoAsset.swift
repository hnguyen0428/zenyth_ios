//
//  InfoAsset.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class InfoAsset: UIButton {
    
    init(image: UIImage, frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("0", for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.setImage(image, for: .normal)
        
//        let widthImage = image.size.width
//        let edgeX = widthImage / 2 + CGFloat(10)
        
//        self.titleEdgeInsets = UIEdgeInsetsMake(0, -edgeX, 0, 0)
//        self.imageEdgeInsets = UIEdgeInsetsMake(0, edgeX, 0, 0)
        self.imageView?.contentMode = .scaleAspectFit
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCount(count: Int) {
        self.setTitle(String(count), for: .normal)
    }
}
