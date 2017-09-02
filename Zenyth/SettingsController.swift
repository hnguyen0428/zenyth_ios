//
//  SettingsController.swift
//  Zenyth
//
//  Created by Hoang on 8/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: HomeController {
    
    var logoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton?.addTarget(self, action: #selector(alertLoggingOut), for: .touchUpInside)
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)

    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        
        let height = view.frame.height * 0.07
        let width = view.frame.width
        let y = view.frame.height * 0.20
        let frame = CGRect(x: 0, y: y, width: width, height: height)
        logoutButton = UIButton(frame: frame)
        
        logoutButton!.layer.borderWidth = 1
        logoutButton!.layer.borderColor = UIColor.lightGray.cgColor
        logoutButton?.setTitle("Logout", for: .normal)
        logoutButton?.setTitleColor(UIColor.purple, for: .normal)
        logoutButton?.contentHorizontalAlignment = .left
        logoutButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0)
        view.addSubview(logoutButton!)
    }
    
    func alertLoggingOut() {
        let alert = UIAlertController(title: nil,
                                      message: "Log Out of Zenyth?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: {
            action in
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
                            NavigationStacks.shared.clearStacks()
                            appDelegate.window!.rootViewController = loginController
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
