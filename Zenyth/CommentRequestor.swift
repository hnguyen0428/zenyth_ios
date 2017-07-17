//
//  CommentRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CommentCreateRequestor: Requestor {
    let commentCreateRoute = Route(method: .post,
                            urlString: "\(serverAddress)/api/comment/create")
    
    init(parameters: Parameters) {
        super.init(route: self.commentCreateRoute, parameters: parameters,
                   needsAuthorization: true)
    }
}

class CommentReadRequestor: Requestor {
    var commentReadRoute = Route(method: .get,
                            urlString: "\(serverAddress)/api/comment/read/%d")
    
    init(comment_id: Int64) {
        commentReadRoute.urlString = String(format: commentReadRoute.urlString,
                                            comment_id)
        super.init(route: self.commentReadRoute)
    }
}

class CommentUpdateRequestor: Requestor {
    var commentUpdateRoute = Route(method: .post,
                            urlString: "\(serverAddress)/api/comment/update/%d")
    
    init(parameters: Parameters, comment_id: Int64) {
        commentUpdateRoute.urlString = String(
            format: commentUpdateRoute.urlString, comment_id)
        super.init(route: self.commentUpdateRoute, parameters: parameters,
                   needsAuthorization: true)
    }
}

class CommentDeleteRequestor: Requestor {
    var commentDeleteRoute = Route(method: .delete,
                            urlString: "\(serverAddress)/api/comment/delete/%d")
    
    init(parameters: Parameters, comment_id: Int64) {
        commentDeleteRoute.urlString = String(
            format: commentDeleteRoute.urlString, comment_id)
        super.init(route: self.commentDeleteRoute, parameters: parameters,
                   needsAuthorization: true)
    }
}
