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
    weak var searchButton: UIButton?
    weak var recenterButton: UIButton?
    var loadedPins: [UInt32] = [UInt32]()
    
    static let LONG_PRESS_DURATION = 1.5
    
    init(frame: CGRect, controller: UIViewController, zoom: Float,
         coord: CLLocationCoordinate2D? = nil) {
        super.init(frame: frame)
        let view = controller.view!
        
        var camera: GMSCameraPosition!
        if let camCoord = coord {
            camera = GMSCameraPosition.camera(withLatitude: camCoord.latitude,
                                                  longitude: camCoord.longitude,
                                                  zoom: zoom)
        }
        else {
            camera = GMSCameraPosition.camera(withLatitude: 33.81, longitude: -117.94,
                                                  zoom: zoom)
        }
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
        
        let searchButton = UIButton(frame: searchButtonFrame)
        self.searchButton = searchButton
        let recenterButton = UIButton(frame: recenterButtonFrame)
        self.recenterButton = recenterButton
        
        searchButton.setImage(#imageLiteral(resourceName: "search_icon"), for: .normal)
        recenterButton.setImage(#imageLiteral(resourceName: "recenter_icon"), for: .normal)
        
        self.addSubview(searchButton)
        self.addSubview(recenterButton)
    }
    
    func loadMarkers(pinposts: [Pinpost]) {
        let filteredPinposts = self.filterOutLoadedPinposts(pinposts: pinposts)
        
        for pinpost in filteredPinposts {
            let lat = pinpost.latitude
            let long = pinpost.longitude
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let marker = GMSMarker(position: position)
            
            marker.map = self
            marker.userData = pinpost.id
            let width = self.frame.width * FeedController.WIDTH_OF_PIN
            let height = width
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            if let image = pinpost.images.first {
                let view = CustomMarkerView(frame: frame, image: image)
                marker.iconView = view
            }
            self.loadedPins.append(pinpost.id)
        }
    }
    
    func filterOutLoadedPinposts(pinposts: [Pinpost]) -> [Pinpost] {
        var filteredPinposts: [Pinpost] = [Pinpost]()
        for pinpost in pinposts {
            if !self.loadedPins.contains(pinpost.id) {
                filteredPinposts.append(pinpost)
            }
        }
        return filteredPinposts
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
