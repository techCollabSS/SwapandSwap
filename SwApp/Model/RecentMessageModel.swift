//
//  RecentMessageModel.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/3/22.
//
import Foundation

struct RecentMessageModel: Identifiable, Codable, Hashable {
    
    var id: String
    var chatUserId: String
    var chatDisplayName: String
    var lastMessageText: String
    var timestamp: Date

   // var received: Bool // If the user is the sender then False
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
