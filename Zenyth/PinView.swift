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
    
    // UI Sizing
    static let HEIGHT_OF_PIN_VIEW: CGFloat = 0.15
    static let LEFT_INSET: CGFloat = 0.025
    static let GAP: CGFloat = 0.05
    
    init(view: UIView) {
        let height = view.frame.width * PinView.HEIGHT_OF_PIN_VIEW
        let width = view.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        
        let margin = view.frame.width * PinView.LEFT_INSET
        let gap = view.frame.width * PinView.GAP
        
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
        let image = UIImageView()
        let container = image.roundedImageWithShadow(frame: frame)
        
        self.addSubview(container)
        return image
    }
}
