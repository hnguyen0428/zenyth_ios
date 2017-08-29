//
//  CropAreaView.swift
//  Zenyth
//
//  Created by Hoang on 8/24/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class CropAreaView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
