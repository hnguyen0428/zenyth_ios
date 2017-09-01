//
//  PaddedTextField.swift
//  Zenyth
//
//  Created by Hoang on 8/31/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class PaddedTextField: UITextField {
    
    var padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, padding, 0, padding))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, padding, 0, padding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, padding, 0, padding))
    }
}
