//
//  CommentModel.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import Foundation
import SwiftUI

struct CommentModel: Identifiable, Hashable {
    
    var id = UUID()
    var commentID: String // ID for the comment in the Database
    var userID: String // ID for the User in the Database
    var username: String // Username for the user in the Database
    var content: String // Comment Text
    var dateCreated: Date // Comment creation date.
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
