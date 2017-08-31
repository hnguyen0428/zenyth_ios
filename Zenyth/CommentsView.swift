//
//  CommentsView.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class CommentsView: UIView {
    
    var comments: [Comment] = [Comment]()
    var commentCells: [CommentCell] = [CommentCell]()
    var commentFrame: CGRect!
    var numComments = 0
    var maxHeight: CGFloat = 0
    
    init(commentFrame: CGRect, comments: [Comment]) {
        self.commentFrame = commentFrame
        super.init(frame: commentFrame)
        
        for comment in comments {
            self.comments.append(comment)
            self.append(comment: comment)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func append(comment: Comment) {
        let y = commentFrame.height * CGFloat(numComments)
        let frame = CGRect(x: self.frame.origin.x, y: y,
                           width: commentFrame.width, height: commentFrame.height)
        let commentCell = CommentCell(frame: frame,
                                      comment: comment)
        self.commentCells.append(commentCell)
        self.addSubview(commentCell)
        let newHeight = self.frame.height + commentFrame.height
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y,
                            width: self.frame.width, height: newHeight)
        
        numComments += 1
        maxHeight += commentFrame.height
    }
}
