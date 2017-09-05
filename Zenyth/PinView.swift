//
//  PinView.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class PinView: UIScrollView {
    
    var pinThumbnails: [PinThumbnail] = [PinThumbnail]()
    var numPins = 0
    weak var controller: UIViewController!
    
    // UI Sizing
    static let LEFT_INSET: CGFloat = 0.025
    static let GAP: CGFloat = 0.05
    static let HEIGHT_IMAGE: CGFloat = 0.95
    
    init(_ controller: UIViewController, frame: CGRect, pinposts: [Pinpost]) {
        self.controller = controller
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.contentSize.width = 0
        self.contentSize.height = self.frame.height
        
        for pinpost in pinposts {
            // Only append pin image if the pinpost has an image
            if let _ = pinpost.images.first {
                self.appendPinImage(pinpost: pinpost)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func appendPinImage(pinpost: Pinpost) {
        let leftInset = self.frame.width * PinView.LEFT_INSET
        // width of image is the same as height of the pinview
        let numPins = CGFloat(self.numPins)
        let height = self.frame.height * PinView.HEIGHT_IMAGE
        let width = height
        let x = leftInset + (numPins * width) +
            (numPins * self.frame.width * PinView.GAP)
        let y = CGFloat(0)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let image = PinThumbnail(frame: frame, pinpost: pinpost)
        image.delegate = self.controller as? PinThumbnailDelegate
        let container = image.roundedImageWithShadow(frame: frame)
        self.addSubview(container)
        self.contentSize.width = container.frame.maxX + leftInset
        self.numPins += 1
    }
    
    deinit {
        debugPrint("Deinitializing \(self)")
    }
}
