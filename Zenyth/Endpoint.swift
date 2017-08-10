//
//  Endpoint.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import Alamofire

/// Used for testing purposes
let localhostURL = "http://172.31.99.37/api"

var baseURL = "http://54.219.134.56/api"
typealias APIRoute = (String, HTTPMethod)

public enum Endpoint {
    
    /// RegistrationManager Endpoints
    case Register
    case OAuthRegister
    
    /// LoginManager Endpoints
    case Login
    case OAuthLogin
    
    /// CredentialManager Endpoints
    case ValidateUsername(String)
    case ValidateEmail(String)
    case SendResetPasswordEmail
    
    /// UserManager Endpoints
    case GetFriends(UInt32)
    case GetBlockedUsers
    case GetFriendRequests
    case ReadProfile(UInt32)
    case UpdateProfile
    case UpdateProfilePicture
    case SearchUser
    
    /// PinpostManager Endpoints
    case CreatePinpost
    case UpdatePinpost(UInt32)
    case UploadImageToPinpost(UInt32)
    case ReadPinpostInfo(UInt32)
    case ReadPinpostImages(UInt32)
    case DeletePinpost(UInt32)
    case GetCommentsOnPinpost(UInt32)
    case GetLikesOnPinpost(UInt32)
    case FetchPinposts
    
    /// CommentManager Endpoints
    case CreateCommentOnPinpost(UInt32)
    case UpdateComment(UInt32)
    case UploadImageToComment(UInt32)
    case ReadCommentInfo(UInt32)
    case ReadCommentImages(UInt32)
    case DeleteComment(UInt32)
    case GetLikesOnComment(UInt32)
    case GetRepliesOnComment(UInt32)
    
    /// ReplyManager Endpoints
    case CreateReplyOnComment(UInt32)
    case UpdateReply(UInt32)
    case UploadImageToReply(UInt32)
    case ReadReplyInfo(UInt32)
    case ReadReplyImages(UInt32)
    case DeleteReply(UInt32)
    case GetLikesOnReply(UInt32)
    
    /// LikeManager Endpoints
    case CreateLikeOnPinpost(UInt32)
    case CreateLikeOnComment(UInt32)
    case CreateLikeOnReply(UInt32)
    case ReadLike(UInt32)
    case DeleteLike(UInt32)
    
    /// RelationshipManager Endpoints
    case SendFriendRequests
    case RespondToFriendRequests
    case DeleteFriend(UInt32)
    case BlockUser
    
    /// ImageManager Endpoints
    case GetImageData(UInt32)
    case DeleteImage(UInt32)
    
    /// TagManager Endpoints
    case SearchTag
    case GetTagInfo
    
    func route() -> APIRoute {
        switch self {
        case .Register:
            return ("\(baseURL)/register", .post)
        case .OAuthRegister:
            return ("\(baseURL)/oauth/register", .post)
            
        case .Login:
            return ("\(baseURL)/login", .post)
        case .OAuthLogin:
            return ("\(baseURL)/oauth/login", .post)
            
        case .ValidateEmail(let email):
            return ("\(baseURL)/email_taken/\(email)", .get)
        case .ValidateUsername(let username):
            return ("\(baseURL)/username_taken/\(username)", .get)
        case .SendResetPasswordEmail:
            return ("\(baseURL)/password/send_reset_password", .post)
            
        case .GetFriends(let userId):
            return ("\(baseURL)/user/get_friends/\(userId)", .get)
        case .GetBlockedUsers:
            return ("\(baseURL)/user/blocked_users", .get)
        case .GetFriendRequests:
            return ("\(baseURL)/user/friend_requests", .get)
        case .ReadProfile(let userId):
            return ("\(baseURL)/profile/\(userId)", .get)
        case .UpdateProfile:
            return ("\(baseURL)/profile", .patch)
        case .UpdateProfilePicture:
            return ("\(baseURL)/profile/profile_picture/upload", .post)
        case .SearchUser:
            return ("\(baseURL)/user/search_user", .get)
            
        case .CreatePinpost:
            return ("\(baseURL)/pinpost", .post)
        case .UpdatePinpost(let pinpostId):
            return ("\(baseURL)/pinpost/\(pinpostId)", .patch)
        case .UploadImageToPinpost(let pinpostId):
            return ("\(baseURL)/pinpost/upload_image/\(pinpostId)", .post)
        case .ReadPinpostInfo(let pinpostId):
            return ("\(baseURL)/pinpost/read/\(pinpostId)", .get)
        case .ReadPinpostImages(let pinpostId):
            return ("\(baseURL)/pinpost/images/\(pinpostId)", .get)
        case .DeletePinpost(let pinpostId):
            return ("\(baseURL)/pinpost/\(pinpostId)", .delete)
        case .GetCommentsOnPinpost(let pinpostId):
            return ("\(baseURL)/pinpost/get_comments/\(pinpostId)", .get)
        case .GetLikesOnPinpost(let pinpostId):
            return ("\(baseURL)/pinpost/get_likes/\(pinpostId)", .get)
        case .FetchPinposts:
            return ("\(baseURL)/pinpost/fetch", .get)
            
        case .CreateCommentOnPinpost(let pinpostId):
            return ("\(baseURL)/pinpost/comment/\(pinpostId)", .post)
        case .UpdateComment(let commentId):
            return ("\(baseURL)/comment/\(commentId)", .patch)
        case .UploadImageToComment(let commentId):
            return ("\(baseURL)/comment/upload_image/\(commentId)", .post)
        case .ReadCommentInfo(let commentId):
            return ("\(baseURL)/comment/read/\(commentId)", .get)
        case .ReadCommentImages(let commentId):
            return ("\(baseURL)/comment/images/\(commentId)", .get)
        case .DeleteComment(let commentId):
            return ("\(baseURL)/comment/\(commentId)", .delete)
        case .GetLikesOnComment(let commentId):
            return ("\(baseURL)/comment/get_likes/\(commentId)", .get)
        case .GetRepliesOnComment(let commentId):
            return ("\(baseURL)/comment/get_replies/\(commentId)", .get)
            
        case .CreateReplyOnComment(let commentId):
            return ("\(baseURL)/reply/\(commentId)", .post)
        case .UpdateReply(let replyId):
            return ("\(baseURL)/reply/\(replyId)", .patch)
        case .UploadImageToReply(let replyId):
            return ("\(baseURL)/reply/upload_image/\(replyId)", .post)
        case .ReadReplyInfo(let replyId):
            return ("\(baseURL)/reply/read/\(replyId)", .get)
        case .ReadReplyImages(let replyId):
            return ("\(baseURL)/reply/images/\(replyId)", .get)
        case .DeleteReply(let replyId):
            return ("\(baseURL)/reply/\(replyId)", .delete)
        case .GetLikesOnReply(let replyId):
            return ("\(baseURL)/reply/get_likes/\(replyId)", .get)
            
        case .CreateLikeOnPinpost(let pinpostId):
            return ("\(baseURL)/pinpost/like/\(pinpostId)", .post)
        case .CreateLikeOnComment(let commentId):
            return ("\(baseURL)/comment/like/\(commentId)", .post)
        case .CreateLikeOnReply(let replyId):
            return ("\(baseURL)/reply/like/\(replyId)", .post)
        case .ReadLike(let likeId):
            return ("\(baseURL)/like/read/\(likeId)", .get)
        case .DeleteLike(let likeId):
            return ("\(baseURL)/like/\(likeId)", .delete)
            
        case .SendFriendRequests:
            return ("\(baseURL)/relationship/friend_request", .post)
        case .RespondToFriendRequests:
            return ("\(baseURL)/relationship/response", .post)
        case .DeleteFriend(let userId):
            return ("\(baseURL)/relationship/delete/\(userId)", .delete)
        case .BlockUser:
            return ("\(baseURL)/relationship/block", .post)
            
        case .GetImageData(let imageId):
            return ("\(baseURL)/image/\(imageId)", .get)
        case .DeleteImage(let imageId):
            return ("\(baseURL)/image/\(imageId)", .delete)
            
        case .SearchTag:
            return ("\(baseURL)/tag/search", .get)
        case .GetTagInfo:
            return ("\(baseURL)/tag/info", .get)
        }
    }
}

