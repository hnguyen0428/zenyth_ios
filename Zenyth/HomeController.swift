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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        setupToolbar()
    }
    
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
    
    func onPressingBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func transitionToFeed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = UINavigationController(rootViewController: FeedController())
        appDelegate.window!.rootViewController = controller
    }
    
    func transitionToNotification() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = NotificationController()
        appDelegate.window!.rootViewController = controller
    }
    
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
