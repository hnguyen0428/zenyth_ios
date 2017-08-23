//
//  FeedScrollView.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class FeedScrollView: UIScrollView {
    
    var pinposts: [Pinpost] = [Pinpost]()
    var currentPinpostIndex = 0
    static let VELOCITY_TO_SWITCH: CGFloat = 500
    static let SWITCH_DURATION: Double = 0.2
    
    init(frame: CGRect, controller: UIViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.contentSize.width = 0
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled
                && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
