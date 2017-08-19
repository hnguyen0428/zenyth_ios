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
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let container = UIView(frame: frame)
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds,
                                                  cornerRadius: frame.height/2).cgPath
        container.layer.shadowColor = UIColor.lightGray.cgColor
        container.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        container.layer.shadowRadius = 2.0
        container.layer.shadowOpacity = 0.5
        
        let image = UIImageView(frame: container.bounds)
        image.layer.cornerRadius = frame.height/2
        image.clipsToBounds = true
        
        image.backgroundColor = UIColor.clear
        container.addSubview(image)
        self.addSubview(container)
        return image
    }
}
