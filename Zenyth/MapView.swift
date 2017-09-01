//
//  MapView.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

/**
 The customized GMSMapView
 */
class MapView: GMSMapView {
    var searchButton: UIButton?
    var recenterButton: UIButton?
    
    static let LONG_PRESS_DURATION = 1.5
    
    init(frame: CGRect, controller: UIViewController) {
        super.init(frame: frame)
        let view = controller.view!
        let camera = GMSCameraPosition.camera(withLatitude: 33.81, longitude: -117.94, zoom: 13.0)
        self.camera = camera
        
        let buttonHeight = view.frame.height * 0.06
        let buttonWidth = buttonHeight
        
        let horizontalMargin: CGFloat = 10.0
        
        let searchButtonX = view.frame.width - buttonWidth - horizontalMargin
        let searchButtonY = view.frame.height * 0.6
        let searchButtonFrame = CGRect(x: searchButtonX, y: searchButtonY,
                                       width: buttonWidth, height: buttonHeight)
        
        let buttonGap: CGFloat = view.frame.height * 0.02
        
        let recenterButtonX = searchButtonX
        let recenterButtonY = searchButtonY + buttonHeight + buttonGap
        let recenterButtonFrame = CGRect(x: recenterButtonX, y: recenterButtonY,
                                         width: buttonWidth, height: buttonHeight)
        
        searchButton = UIButton(frame: searchButtonFrame)
        recenterButton = UIButton(frame: recenterButtonFrame)
        
        searchButton!.setImage(#imageLiteral(resourceName: "search_icon"), for: .normal)
        recenterButton!.setImage(#imageLiteral(resourceName: "recenter_icon"), for: .normal)
        
        self.addSubview(searchButton!)
        self.addSubview(recenterButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
