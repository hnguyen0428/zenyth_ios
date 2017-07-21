//
//  MapController.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {
    
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var mask: UIView?
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navButton.addTarget(self, action: #selector(showNavView), for: .touchUpInside)
        signoutButton.addTarget(self, action: #selector(signout), for: .touchUpInside)
        loadMap()
        
        tapGesture.addTarget(self, action: #selector(hideNavView))
        view.addGestureRecognizer(tapGesture)
        navButton.backgroundColor = .clear
        
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
    
    func showNavView(_ button: UIButton) {
        mask = UIView(frame: self.view.frame)
        mask!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(self.mask!)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.navView.frame.origin.x = 0
            self.mask!.frame.origin.x = self.navView.frame.width
        })
    }
    
    func hideNavView(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: self.view)
        let view = self.view.hitTest(location, with: nil)
        
        if view != navView {
            self.mask!.removeFromSuperview()
            UIView.animate(withDuration: 0.1, animations: {
                self.navView.frame.origin.x = -self.navView.frame.width
            })
        }
        
    }
    
    func signout() {
        let alert = UIAlertController(title: "Log Out of Zenyth?", message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: { action in
            self.transitionToLogin()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func transitionToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
        let loginController: UINavigationController =
            storyboard.instantiateInitialViewController()
        as! UINavigationController;
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(with: appDelegate.window!, duration: 0.5, options: .transitionCrossDissolve,
                          animations: {
            appDelegate.window!.rootViewController = loginController
        }, completion: nil)
    }
    
}
