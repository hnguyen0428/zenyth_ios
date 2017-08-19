//
//  UIImageView+ImageFromURL.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

typealias Handler = (Void) -> Void

extension UIImageView {
    func imageFromUrl(withUrl url: String, handler: Handler? = nil) {
        ImageManager().getImageData(withUrl: url,
                                    onSuccess:
            { data in
                self.image = UIImage(data: data)
                handler?()
        })
    }
}
