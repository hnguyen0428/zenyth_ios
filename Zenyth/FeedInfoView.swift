//
//  FeedInfoView.swift
//  Zenyth
//
//  Created by Hoang on 8/22/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class FeedInfoView: UIView {
    
    weak var titleLabel: UILabel?
    weak var creatorLabel: UILabel?
    weak var descriptionText: UITextView?
    var pinpost: Pinpost!
    
    // Pinpost actions
    weak var actionBar: PostActionBar?
    
    var maxHeight: CGFloat = 0.0
    
    // Height based on percentage
    static let HEIGHT_OF_TITLE_LABEL: CGFloat = 0.13
    static let HEIGHT_OF_CREATOR_LABEL: CGFloat = 0.09
    static let HEIGHT_OF_DESCRIPTION_TEXT: CGFloat = 0.54
    static let GAP_B_TOP_A_TITLE_LABEL: CGFloat = 0.02
    static let GAP_B_TITLE_A_CREATOR: CGFloat = 0.02
    static let GAP_B_CREATOR_A_DESCRIPTION: CGFloat = 0.02
    static let GAP_B_DESCRIPTION_A_ACTIONBAR: CGFloat = 0.04
    static let GAP_B_BOTTOM_A_ACTIONBAR: CGFloat = 0.04
    static let HEIGHT_OF_ACTIONBAR: CGFloat = 1.0 - GAP_B_TOP_A_TITLE_LABEL -
        HEIGHT_OF_TITLE_LABEL - HEIGHT_OF_CREATOR_LABEL -
        HEIGHT_OF_DESCRIPTION_TEXT - GAP_B_TOP_A_TITLE_LABEL - GAP_B_TITLE_A_CREATOR -
        GAP_B_CREATOR_A_DESCRIPTION - GAP_B_BOTTOM_A_ACTIONBAR
    
    
    
    // Width based on percentage
    static let WIDTH_OF_TITLE_LABEL: CGFloat = 0.60
    static let WIDTH_OF_CREATOR_LABEL: CGFloat = 0.30
    static let WIDTH_OF_DESCRIPTION_TEXT: CGFloat = 0.95
    static let WIDTH_OF_ACTION_BAR: CGFloat = 0.50
    
    init(_ controller: UIViewController, frame: CGRect, pinpost: Pinpost) {
        self.pinpost = pinpost
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        let title = pinpost.title
        let description = pinpost.pinpostDescription
        let creator = pinpost.creator!
        let username = creator.username
        var name: String? = nil
        if let firstName = creator.firstName,
            let lastName = creator.lastName {
            name = "\(firstName) \(lastName)"
        } else if let firstName = creator.firstName {
            name = firstName
        } else if let lastName = creator.lastName {
            name = lastName
        }
        
        self.setupTitleLabel(title: title)
        self.setupCreatorLabel(name: name, username: username)
        self.setupDescriptionText(description: description)
        self.setupActionBar()
        
        // Resize
        let bottomGap = self.frame.height * FeedInfoView.GAP_B_BOTTOM_A_ACTIONBAR
        maxHeight = maxHeight + bottomGap
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTitleLabel(title: String) {
        let width = self.frame.width * FeedInfoView.WIDTH_OF_TITLE_LABEL
        let height = self.frame.height * FeedInfoView.HEIGHT_OF_TITLE_LABEL
        let x = self.center.x - width/2
        let gap = self.frame.height * FeedInfoView.GAP_B_TOP_A_TITLE_LABEL
        let y = gap
        
        maxHeight = maxHeight + height + gap
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let titleLabel = UILabel(frame: frame)
        self.titleLabel = titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
    }
    
    func setupCreatorLabel(name: String?, username: String) {
        let width = self.frame.width * FeedInfoView.WIDTH_OF_CREATOR_LABEL
        let height = self.frame.height * FeedInfoView.HEIGHT_OF_CREATOR_LABEL
        let x = self.center.x - width/2
        let gap = self.frame.height * FeedInfoView.GAP_B_TITLE_A_CREATOR
        let y = titleLabel!.frame.maxY + gap
        
        maxHeight = maxHeight + height + gap
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let creatorLabel = UILabel(frame: frame)
        self.creatorLabel = creatorLabel
        creatorLabel.font = UIFont.italicSystemFont(ofSize: 12.0)
        creatorLabel.textAlignment = .center
        
        if let str = name {
            creatorLabel.text = "By: \(str)"
        }
        else {
            creatorLabel.text = "By: \(username)"
        }
        
        self.addSubview(creatorLabel)
    }
    
    func setupDescriptionText(description: String) {
        let width = self.frame.width * FeedInfoView.WIDTH_OF_DESCRIPTION_TEXT
        let height = self.frame.height * FeedInfoView.HEIGHT_OF_DESCRIPTION_TEXT
        
        let margin = (self.frame.width - width)/2
        let x = margin
        let gap = self.frame.height * FeedInfoView.GAP_B_CREATOR_A_DESCRIPTION
        let y = creatorLabel!.frame.maxY + gap
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let descriptionText = UITextView(frame: frame)
        self.descriptionText = descriptionText
        descriptionText.font = UIFont(name: "Verdana", size: 16.0)
        descriptionText.text = description
        descriptionText.isEditable = false
        
        self.addSubview(descriptionText)
        
        // Resizing based on length of text
        let contentHeight = descriptionText.contentSize.height
        let newHeight = contentHeight < height ? contentHeight : height
        descriptionText.frame = CGRect(x: x, y: y, width: width, height: newHeight)
        descriptionText.isScrollEnabled = false
        descriptionText.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        maxHeight = maxHeight + newHeight + gap
    }
    
    func setupActionBar() {
        let width = self.frame.width * FeedInfoView.WIDTH_OF_ACTION_BAR
        let height = self.frame.height * FeedInfoView.HEIGHT_OF_ACTIONBAR
        let x = self.center.x - width/2
        let gap = self.frame.height * FeedInfoView.GAP_B_DESCRIPTION_A_ACTIONBAR
        let y = descriptionText!.frame.maxY + gap
        
        maxHeight = maxHeight + height + gap
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let actionBar = PostActionBar(frame: frame)
        self.actionBar = actionBar
        self.addSubview(actionBar)
    }
    
}
