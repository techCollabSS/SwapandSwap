//
//  MessageModel.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/28/22.
//

import Foundation

struct MessageModel: Identifiable, Codable, Hashable {
    
    var fromUserId: String
    var fromDisplayName: String
    var toUserId: String
    var toDisplayName: String
    var id: String
    var messageText: String
    var received: Bool // If the user is the sender then False
    var timestamp: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


let ChatMessageData = [

    MessageModel(fromUserId: "Test123", fromDisplayName: "Test", toUserId: "Test123", toDisplayName: "Test", id: "Ttest123", messageText: "Test", received: false, timestamp: Date()),
]
