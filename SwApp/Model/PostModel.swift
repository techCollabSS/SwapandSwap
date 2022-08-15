//
//  PostModel.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import Foundation
import Swift

struct PostModel: Identifiable, Hashable {
    
    var id = UUID()
    var postID: String // ID for the post in Database
    var userID: String // ID for the user in Database
    var username: String // Username of user in Database
    var postCategory: String
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    // postID
    // userID
    // user username
    // caption - optional
    // date
    // like count
    // like by curent user
}
