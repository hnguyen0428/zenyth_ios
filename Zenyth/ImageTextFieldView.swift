//
//  ImageTextFieldView.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ImageTextFieldView: UIView {
    
    var textfield: UITextField?
    var imageView: UIImageView?
    
    init(frame: CGRect, image: UIImage? = nil) {
        super.init(frame: frame)
        
        let textfieldWidth = frame.width * 0.90
        let textfieldHeight = frame.height
        let textfieldFrame = CGRect(x: 0, y: 0, width: textfieldWidth, height: textfieldHeight)
        textfield = UITextField(frame: textfieldFrame)
        textfield?.bottomBorder()
        
        let imageWidth = (frame.width - textfieldWidth) * 0.60
        let imageHeight = imageWidth
        let imageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView = UIImageView(frame: imageFrame)
        imageView?.contentMode = .scaleAspectFill
        
        if let img = image {
            imageView!.image = img
        }
        
        self.addSubview(textfield!)
        self.addSubview(imageView!)
        
        textfield!.anchor(topAnchor, left: nil, bottom: bottomAnchor,
                          right: rightAnchor, topConstant: 0, leftConstant: 0,
                          bottomConstant: 0, rightConstant: 0,
                          widthConstant: textfieldWidth, heightConstant: textfieldHeight)
        
        let horizontalMargin = ((frame.width - textfieldWidth) - imageWidth) / 2
        let verticalMargin = (frame.height - imageHeight) / 2
        imageView?.anchor(topAnchor, left: nil, bottom: nil,
                          right: textfield?.leftAnchor, topConstant: verticalMargin,
                          leftConstant: 0, bottomConstant: 0,
                          rightConstant: horizontalMargin,
                          widthConstant: imageWidth, heightConstant: imageHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class DoubleTextFieldView: UIView {
    var textfieldOne: UITextField?
    var textfieldTwo: UITextField?
    var imageView: UIImageView?
    
    init(frame: CGRect, image: UIImage? = nil) {
        super.init(frame: frame)
        
        let textfieldWidth = frame.width * 0.44
        let textfieldHeight = frame.height
        
        let textfieldFrame = CGRect(x: 0, y: 0, width: textfieldWidth, height: textfieldHeight)
        textfieldOne = UITextField(frame: textfieldFrame)
        textfieldOne?.bottomBorder()
        textfieldTwo = UITextField(frame: textfieldFrame)
        textfieldTwo?.bottomBorder()
        
        let imageWidth = (frame.width * 0.10) * 0.60
        let imageHeight = imageWidth
        let imageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView = UIImageView(frame: imageFrame)
        imageView?.contentMode = .scaleAspectFill
        
        if let img = image {
            imageView!.image = img
        }
        
        self.addSubview(textfieldOne!)
        self.addSubview(textfieldTwo!)
        self.addSubview(imageView!)
        
        textfieldTwo!.anchor(topAnchor, left: nil, bottom: bottomAnchor,
                             right: rightAnchor, topConstant: 0, leftConstant: 0,
                             bottomConstant: 0, rightConstant: 0,
                             widthConstant: textfieldWidth, heightConstant: textfieldHeight)
        
        let gap = frame.width * 0.02
        textfieldOne!.anchor(topAnchor, left: nil, bottom: bottomAnchor,
                             right: textfieldTwo?.leftAnchor, topConstant: 0, leftConstant: 0,
                             bottomConstant: 0, rightConstant: gap,
                             widthConstant: textfieldWidth, heightConstant: textfieldHeight)
        
        let horizontalMargin = ((frame.width * 0.10) - imageWidth) / 2
        let verticalMargin = (frame.height - imageHeight) / 2
        imageView?.anchor(topAnchor, left: nil, bottom: nil,
                          right: textfieldOne?.leftAnchor, topConstant: verticalMargin,
                          leftConstant: 0, bottomConstant: 0,
                          rightConstant: horizontalMargin,
                          widthConstant: imageWidth, heightConstant: imageHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
