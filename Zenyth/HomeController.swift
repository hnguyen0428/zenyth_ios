//
//  HomeController.swift
//  Zenyth
//
//  Created by Hoang on 7/21/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    var toolbar: Navbar?
    var backButton: UIBarButtonItem?
    
    /**
     Called when the view has finished loading. Immediately call setupViews()
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    /**
     All UI Component setup goes here
     */
    func setupViews() {
        setupToolbar()
    }
    
    /**
     Setting up the tool bar at the bottom
     */
    func setupToolbar() {
        toolbar = Navbar(view: self.view)
        view.addSubview(toolbar!)
        view.backgroundColor = UIColor.white
        
        let backButton: UIButton = {
            let frame = CGRect(x: 0, y: 0, width: 15,
                               height: 25)
            let button = UIButton(frame: frame)
            button.contentMode = .scaleAspectFill
            button.backgroundColor = .clear
            button.setImage(#imageLiteral(resourceName: "back_black"), for: .normal)
            button.addTarget(self, action: #selector(onPressingBack),
                             for: .touchUpInside)
            return button
        }()
        let barButton = UIBarButtonItem(customView: backButton)
        self.backButton = barButton
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    /**
     Used as a target for the customized back button added to the navigation
     bar
     */
    func onPressingBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Transition to FeedController
     */
    func transitionToFeed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = UINavigationController(rootViewController: FeedController())
        appDelegate.window!.rootViewController = controller
    }
    
    /**
     Transition to NotificationController
     */
    func transitionToNotification() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = NotificationController()
        appDelegate.window!.rootViewController = controller
    }
    
    /**
     Transition to ProfileController
     */
    func transitionToProfile() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let profileController = ProfileController()
        let controller = UINavigationController(rootViewController: profileController)
        let userId = UserDefaults.standard.object(forKey: "id") as! UInt32
        profileController.userId = userId
        profileController.shouldSetProfileSelected = true
        
        appDelegate.window!.rootViewController = controller
    }
}
