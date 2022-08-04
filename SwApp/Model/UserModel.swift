//
//  UserModel.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/31/22.
//

import Foundation
import Swift

struct UserModel: Identifiable, Hashable, Codable {
    
    var id: String
    var displayName: String
    var email: String
    var providerID: String
    var provider: String
    var userID: String
    var bio: String
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
