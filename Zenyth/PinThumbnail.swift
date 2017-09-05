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
    
    var pinpost: Pinpost!
    weak var delegate: PinThumbnailDelegate?
    
    static let LONG_PRESS_DURATION: Double = 0.8
    
    init(frame: CGRect, pinpost: Pinpost) {
        self.pinpost = pinpost
        super.init(frame: frame)
        
        if let image = pinpost.images.first {
            let url = URL(string: image.getURL(size: .small))
            self.sd_setImage(with: url)
        }
        self.isUserInteractionEnabled = true
        let tg = UITapGestureRecognizer(target: self, action: #selector(self.expandPinpost))
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        lp.minimumPressDuration = PinThumbnail.LONG_PRESS_DURATION
        self.addGestureRecognizer(tg)
        self.addGestureRecognizer(lp)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func expandPinpost(_ tg: UITapGestureRecognizer) {
        let controller = ExpandedFeedController()
        controller.pinpostId = pinpost.id
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        
        if let nc = self.window?.rootViewController as? UINavigationController {
            nc.view.layer.add(transition, forKey: nil)
            nc.pushViewController(controller, animated: false)
        }
    }
    
    func didLongPress(_ lp: UILongPressGestureRecognizer) {
        delegate?.didLongPress(on: pinpost)
    }
    
    deinit {
        debugPrint("Deinitializing \(self)")
    }
}

protocol PinThumbnailDelegate: class {
    func didLongPress(on pinpost: Pinpost)
}
