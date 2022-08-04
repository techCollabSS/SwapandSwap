//
//  RecenMessageService.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/3/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecentMessagesService: ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
        
    @State var toUserId: String?
    
    @Published var recentMessages = [RecentMessageModel]()
    
    @Published var empty = false

    private var REF_MESSAGES = DB_BASE.collection("messages")
    
    let db = Firestore.firestore()
    
    
    init() {
        
        if currentUserID != nil {
                getAllRecentMessages()

        }
    }
    
    
    // MARK: GET FUNCTIONS
    
    func getAllRecentMessages() {

        if self.currentUserID != nil {

            db.collection("messages").document(currentUserID!).collection("recents").getDocuments { (snap, err) in

            if err != nil{

                print((err?.localizedDescription)!)
                self.empty = true
                return
            }

            if (snap?.documents.isEmpty)!{

                self.empty = true
                return
            }

            for i in snap!.documents {

                let id = i.documentID
                let chatUserId = i.get("chatUserId") as! String
                let chatDisplayName = i.get("chatDisplayName") as! String
                let lastMessageText = i.get("lastMessageText") as! String
                let timestamp = i.get("timestamp") as! Timestamp

                if id != self.currentUserID! {

                    self.recentMessages.append(RecentMessageModel(id: id,
                                                                  chatUserId: chatUserId,
                                                                  chatDisplayName: chatDisplayName,
                                                                  lastMessageText: lastMessageText,
                                                                  timestamp: timestamp.dateValue()))
                    }
                }

            if self.recentMessages.isEmpty{

                self.empty = true
                }
            }
        }
    }
}
