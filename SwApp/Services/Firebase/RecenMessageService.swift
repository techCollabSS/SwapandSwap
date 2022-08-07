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
    
    static let instance = RecentMessagesService()
    
    @Published private(set) var recentText = ""
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
                
    @Published private(set) var recentMessages: [RecentMessageModel] = []
    
    @Published var empty = false


    private var REF_MESSAGES = DB_BASE.collection("messages")
    
    let db = Firestore.firestore()
    
    
    init() {
        
        if currentUserID != nil {
                getAllRecentMessages()

        }
    }
    
    
    // MARK: GET FUNCTIONS
    
    func getAllRecentMessages()  {
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
                let read = i.get("read") as! Bool
                let timestamp = i.get("timestamp") as! Timestamp

                if id != self.currentUserID! {

                    self.recentMessages.append(RecentMessageModel(id: id,
                                                                  chatUserId: chatUserId,
                                                                  chatDisplayName: chatDisplayName,
                                                                  lastMessageText: lastMessageText,
                                                                  read: read,
                                                                  timestamp: timestamp.dateValue()))
                    
                    }
                }

            if self.recentMessages.isEmpty{

                self.empty = true
                }
                
                if let recentText = self.recentMessages.last?.lastMessageText {
                    self.recentText = recentText
                }
                
            }
            
        }
    }
    
    func recentMessageOnAppear(userId: String, handler: @escaping (_ lastMessageText: String?, _ read: Bool?, _ timestamp: Date?) -> ()) {
        
        REF_MESSAGES.document(currentUserID!).collection("recents").document(userId).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let lastMessageText = document.get("lastMessageText") as? String,
               let read = document.get("read") as? Bool,
               let timestamp = document.get("timestamp") as? Timestamp {
                print("Success getting user Recent Messages")
                handler(lastMessageText, read, timestamp.dateValue())
                return
            } else {
                print("Error getting user Recent Messages")
                handler(nil, nil, nil)
                return
            }
        }
        
    }
    
    func updateRecentsOnRead (fromUserId: String, toUserId: String, read: Bool) {
        
        // Update From Recents
        self.db.collection("messages").document(fromUserId).collection("recents").document(toUserId).updateData(["read":read])
        
        // Update To Recents
        self.db.collection("messages").document(toUserId).collection("recents").document(fromUserId).updateData(["read":read])
        
        print("Success Reading Recent Message")

    }
    
}
