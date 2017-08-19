//
//  PinView.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class PinView: UIView {
    
    var pinImages: [UIImageView] = [UIImageView]()
    
    init(view: UIView) {
        let height = view.frame.width * 0.15
        let width = view.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        
        let margin = view.frame.width * 0.025
        let gap = view.frame.width * 0.05
        
        let widthImage = height
        let heightImage = widthImage
        
        for i in 0..<5 {
            let x = margin + CGFloat(i) * gap + CGFloat(i) * widthImage
            let pinImage = self.setupImageView(x: x, y: 0, width: widthImage, height: heightImage)
            pinImages.append(pinImage)
            self.addSubview(pinImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let image = UIImageView(frame: frame)
        
        image.layer.masksToBounds = false
        image.layer.cornerRadius = frame.height / 2
        image.clipsToBounds = true
        
        image.backgroundColor = UIColor.clear
        return image
    }
}
