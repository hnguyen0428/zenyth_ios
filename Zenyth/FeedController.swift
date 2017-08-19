//
//  FeedController.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

class FeedController: HomeController {
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        toolbar?.setHomeSelected()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 33.81, longitude: -117.94, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.frame = self.view.frame
        self.mapView = mapView
        view.insertSubview(mapView, at: 0)
    }
}
