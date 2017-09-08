//
//  CommentCell.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

/**
 Each of comment cell
 */
class CommentCell: UIView {
    
    weak var profilePicView: UIImageView?
    weak var usernameLabel: UILabel?
    weak var commentField: UITextView?
    var comment: Comment?
    
    // Constants for ui sizing
    static let LEFT_INSET: CGFloat = 0.03
    static let TOP_INSET: CGFloat = 0.05
    
    static let PROFILE_PIC_HEIGHT: CGFloat = 0.90
    static let USERNAME_HEIGHT: CGFloat = 0.29
    static let USERNAME_WIDTH: CGFloat = 0.30
    static let COMMENT_HEIGHT: CGFloat = 0.65
    static let COMMENT_WIDTH: CGFloat = 0.80
    
    static let GAP_B_PIC_A_COMMENT: CGFloat = 0.05
    static let GAP_B_USERNAME_A_COMMENT: CGFloat = 0.05
    static let TOP_BORDER_THICKNESS: CGFloat = 0.5
    
    init(frame: CGRect, comment: Comment) {
        self.comment = comment
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePicView(user: comment.creator!)
        setupUsernameLabel(username: comment.creator!.username)
        setupCommentField(text: comment.text)
        
        self.topBorder(color: UIColor.lightGray.cgColor,
                       width: CommentCell.TOP_BORDER_THICKNESS)
        
        let tg = UITapGestureRecognizer(target: self, action: #selector(gotoProfile))
        profilePicView!.isUserInteractionEnabled = true
        profilePicView!.addGestureRecognizer(tg)
    }
    
    func setupProfilePicView(user: User) {
        let height = self.frame.height * CommentCell.PROFILE_PIC_HEIGHT
        let width = height
        let x = self.frame.width * CommentCell.LEFT_INSET
        let y = self.frame.height * CommentCell.TOP_INSET
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let profilePicView = UIImageView(frame: frame)
        self.profilePicView = profilePicView
        
        if let image = user.profilePicture {
            let url = URL(string: image.getURL(size: .small))
            profilePicView.sd_setImage(with: url,
                                       placeholderImage: #imageLiteral(resourceName: "default_profile"))
        }
        else {
            profilePicView.image = #imageLiteral(resourceName: "default_profile")
        }
        
        let container = profilePicView.roundedImageWithShadow(frame: frame)
        self.addSubview(container)
    }
    
    func setupUsernameLabel(username: String) {
        let height = self.frame.height * CommentCell.USERNAME_HEIGHT
        let width = self.frame.width * CommentCell.USERNAME_WIDTH
        let gap = self.frame.width * CommentCell.GAP_B_PIC_A_COMMENT
        let x = profilePicView!.frame.maxX + gap
        let y = self.frame.height * CommentCell.TOP_INSET
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let usernameLabel = UILabel(frame: frame)
        self.usernameLabel = usernameLabel
        usernameLabel.text = username
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        self.addSubview(usernameLabel)
    }
    
    func setupCommentField(text: String) {
        let height = self.frame.height * CommentCell.COMMENT_HEIGHT
        let width = self.frame.width * CommentCell.COMMENT_WIDTH
        let x = usernameLabel!.frame.origin.x
        let gap = self.frame.height * CommentCell.GAP_B_USERNAME_A_COMMENT
        let y = usernameLabel!.frame.maxY + gap
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let commentField = UITextView(frame: frame)
        self.commentField = commentField
        commentField.text = text
        commentField.font = UIFont.systemFont(ofSize: 12.0)
        commentField.isEditable = false
        commentField.textContainerInset = UIEdgeInsets.zero
        commentField.textContainer.lineFragmentPadding = 0
        
        self.addSubview(commentField)
    }
    
    func gotoProfile(_ tg: UITapGestureRecognizer) {
        let controller = ProfileController()
        controller.userId = comment!.creator!.id
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        
        if let nc = self.window?.rootViewController as? UINavigationController {
            nc.view.layer.add(transition, forKey: nil)
            nc.pushViewController(controller, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
