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
        let nc = self.navigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stackIndex = NavigationStacks.shared.stackIndex
        // If the current stack is the feed stack, and we press on the feed
        // button then we pop back to root
        if stackIndex == 0 {
            if nc?.topViewController != nc?.viewControllers.first {
                nc?.popToRootViewController(animated: true)
            }
            else {
                let controller = UINavigationController(rootViewController: FeedController())
                NavigationStacks.shared.feedNC = controller
                appDelegate.window!.rootViewController = controller
            }
        } else {
            if let nc = NavigationStacks.shared.feedNC {
                appDelegate.window!.rootViewController = nc
            }
            else {
                let controller = UINavigationController(rootViewController: FeedController())
                NavigationStacks.shared.feedNC = controller
                appDelegate.window!.rootViewController = controller
            }
        }
        NavigationStacks.shared.stackIndex = 0
    }
    
    /**
     Transition to NotificationController
     */
    func transitionToNotification() {
        let nc = self.navigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stackIndex = NavigationStacks.shared.stackIndex
        // If the current stack is the notification stack, and we press on the notification
        // button then we pop back to root, else we reload
        if stackIndex == 1 {
            if nc?.topViewController != nc?.viewControllers.first {
                nc?.popToRootViewController(animated: true)
            }
            else {
                let controller = UINavigationController(rootViewController: NotificationController())
                NavigationStacks.shared.notificationNC = controller
                appDelegate.window!.rootViewController = controller
            }
        } else {
            if let nc = NavigationStacks.shared.notificationNC { // stack was saved
                appDelegate.window!.rootViewController = nc
            }
            else {
                let controller = UINavigationController(rootViewController: NotificationController())
                NavigationStacks.shared.notificationNC = controller
                appDelegate.window!.rootViewController = controller
            }
        }
        NavigationStacks.shared.stackIndex = 1
    }
    
    /**
     Transition to ProfileController
     */
    func transitionToProfile() {
        let nc = self.navigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stackIndex = NavigationStacks.shared.stackIndex
        // If the current stack is the profile stack, and we press on the profile
        // button then we pop back to root
        if stackIndex == 2 {
            if nc?.topViewController != nc?.viewControllers.first {
                nc?.popToRootViewController(animated: true)
            }
            else {
                let profileController = ProfileController()
                let controller = UINavigationController(rootViewController: profileController)
                NavigationStacks.shared.profileNC = controller
                let userId = UserDefaults.standard.object(forKey: "id") as! UInt32
                profileController.userId = userId
                
                appDelegate.window!.rootViewController = controller
            }
        } else { // If not then we transition to profile
            if let nc = NavigationStacks.shared.profileNC { // if there was a saved stack use it
                appDelegate.window!.rootViewController = nc
            }
            else {
                let profileController = ProfileController()
                let controller = UINavigationController(rootViewController: profileController)
                NavigationStacks.shared.profileNC = controller
                let userId = UserDefaults.standard.object(forKey: "id") as! UInt32
                profileController.userId = userId
                
                appDelegate.window!.rootViewController = controller
            }
        }
        NavigationStacks.shared.stackIndex = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setToolbarSelected()
    }
    
    func setToolbarSelected() {
        if NavigationStacks.shared.stackIndex == 0 {
            toolbar?.setHomeSelected()
        }
        if NavigationStacks.shared.stackIndex == 1 {
            toolbar?.setNotificationSelected()
        }
        if NavigationStacks.shared.stackIndex == 2 {
            toolbar?.setProfileSelected()
        }
    }
}
