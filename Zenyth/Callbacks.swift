//
//  Callbacks.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

typealias JSONCallback = (JSON) -> Void
typealias DataCallback = (Data) -> Void
typealias ErrorCallback = (NSError) -> Void

typealias UserCallback = (User) -> Void
typealias UserCallbackWithToken = (User, String) -> Void
typealias UsersCallback = ([User]) -> Void

typealias PinpostCallback = (Pinpost) -> Void
typealias PinpostsCallback = ([Pinpost]) -> Void
typealias PinpostsCallbackWithPaginate = ([Pinpost], Paginate) -> Void

typealias CommentCallback = (Comment) -> Void
typealias CommentsCallback = ([Comment]) -> Void

typealias ReplyCallback = (Reply) -> Void
typealias RepliesCallback = ([Reply]) -> Void

typealias LikeCallback = (Like) -> Void
typealias LikesCallback = ([Like]) -> Void

typealias ImageCallback = (Image) -> Void
typealias ImagesCallback = ([Image]) -> Void

typealias TagCallback = (Tag) -> Void
typealias TagsCallback = ([Tag]) -> Void

typealias RelationshipCallback = (Relationship) -> Void
typealias RelationshipsCallback = ([Relationship]) -> Void


typealias UIImageCallback = (UIImage) -> Void
