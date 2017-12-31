//
//  ImageViewControllerDelegate.swift
//  Zenyth
//
//  Created by Hoang on 9/1/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

protocol ImageViewControllerDelegate: class {
    func didLongSwipeVertically(sender: ImageViewController)
}
