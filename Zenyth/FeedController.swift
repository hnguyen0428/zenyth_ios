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
    
    var mapView: MapView?
    
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
    
    func loadMap() {
        mapView = MapView(frame: view.frame, view: self.view)
        view.insertSubview(mapView!, at: 0)
    }
}
