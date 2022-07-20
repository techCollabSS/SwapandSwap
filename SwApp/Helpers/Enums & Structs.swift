//
//  Enums & Structs.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/25/21.
//

// NOTE: This is used to create the fields for our database so we can reference in multiple places in the app

import Foundation

struct DatabaseUserField { // Fields within the User Document in Database
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"

}

struct DatabasePostField { // Fields within Post Document in Database
    
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    static let likeCount = "like_count" // Integer
    static let likedBy = "liked_by" // arrray
    static let comments = "comments" // sub-collection of post comments

}

struct DatabaseCommentsField { // Fields within the comment Sub Collection of a Post Document
    
    static let commentID = "comment_id"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let content = "content"
    static let dateCreated = "date_created"

}

struct DatabaseReportField { // Fields within Reports Document in Database
    
    static let content = "content"
    static let postID = "post_id"
    static let dateCreated = "date_created"
    
}

struct CurrentUserDefaults { // Fields for UserDefaults saved within app
    
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}

enum SettingsEditTextOption {
    case displayName
    case bio
}
