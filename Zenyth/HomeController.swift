//
//  HomeController.swift
//  Zenyth
//
//  Created by Hoang on 7/21/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    var toolbar: UIToolbar?
    var tabOne: UIBarButtonItem?
    var tabTwo: UIBarButtonItem?
    var tabThree: UIBarButtonItem?
    var tabFour: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        setupToolbar()
    }
    
    func setupToolbar() {
        toolbar = {
            let viewFrame = self.view.frame
            let height = viewFrame.height * 0.07
            let width = viewFrame.width
            let x = viewFrame.origin.x
            let y = viewFrame.height - height
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let toolbar = UIToolbar(frame: frame)
            toolbar.barStyle = .default
            toolbar.isUserInteractionEnabled = true
            return toolbar
        }()
        
        tabOne = {
            let button = UIBarButtonItem(title: "General Map", style: .plain, target: self, action: nil)
            button.title = "General Map"
            return button
        }()
        
        tabTwo = {
            let button = UIBarButtonItem(title: "User's Map", style: .plain, target: self, action: nil)
            return button
        }()
        
        tabThree = {
            let button = UIBarButtonItem(title: "Pinpost", style: .plain, target: self, action: nil)
            return button
        }()
        
        tabFour = {
            let button = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: nil)
            return button
        }()
        
        let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items: [UIBarButtonItem] = [flexibleSpaceLeft, tabOne!, tabTwo!,
                                        tabThree!, tabFour!, flexibleSpaceRight]
        
        toolbar?.setItems(items, animated: false)
        view.addSubview(toolbar!)
    }
}
