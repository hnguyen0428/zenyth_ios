//
//  PinThumbnail.swift
//  Zenyth
//
//  Created by Hoang on 8/31/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class PinThumbnail: UIImageView {
    
    var imageObj: Image!
    
    init(frame: CGRect, image: Image) {
        self.imageObj = image
        super.init(frame: frame)
        
        self.imageFromUrl(withUrl: image.getURL(size: "medium"))
        self.isUserInteractionEnabled = true
        let tg = UITapGestureRecognizer(target: self, action: #selector(self.expandPinpost))
        self.addGestureRecognizer(tg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func expandPinpost(_ tg: UITapGestureRecognizer) {
        let controller = ExpandedFeedController()
        controller.pinpostId = imageObj.imageableId
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        
        if let nc = self.window?.rootViewController as? UINavigationController {
            nc.view.layer.add(transition, forKey: nil)
            nc.pushViewController(controller, animated: false)
        }
    }
}
