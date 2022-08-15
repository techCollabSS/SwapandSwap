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
                
    @Published private(set) var recentMessages = [RecentMessageModel]()
    
    @Published var empty = false
    @Published var noRecents = false



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

            
            
            db.collection("messages").document(currentUserID!).collection("recents").order(by: "timestamp", descending: true).addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    self.noRecents = true
                    return
                }
                
                if snap!.isEmpty{
                    
                    self.noRecents = true
                }
                
                for i in snap!.documentChanges{
                    
                    if i.type == .added {
                        
                        let id = i.document.documentID
                        let chatUserId = i.document.get("chatUserId") as! String
                        let chatDisplayName = i.document.get("chatDisplayName") as! String
                        let lastMessageText = i.document.get("lastMessageText") as! String
                        let read = i.document.get("read") as! Bool
                        let timestamp = i.document.get("timestamp") as! Timestamp
                        
     
                        
                        self.recentMessages.append(RecentMessageModel(id: id, chatUserId: chatUserId, chatDisplayName: chatDisplayName, lastMessageText: lastMessageText, read: read, timestamp: timestamp.dateValue()))
                    }
                    
                    if i.type == .modified {
                        
                        let id = i.document.documentID
                        let chatUserId = i.document.get("chatUserId") as! String
                        let chatDisplayName = i.document.get("chatDisplayName") as! String
                        let lastMessageText = i.document.get("lastMessageText") as! String
                        let read = i.document.get("read") as! Bool
                        let timestamp = i.document.get("timestamp") as! Timestamp
                        
                        for j in 0..<self.recentMessages.count {
                            
                            if self.recentMessages[j].id == id{
                                
                                self.recentMessages[j].id = id
                                self.recentMessages[j].chatUserId = chatUserId
                                self.recentMessages[j].chatDisplayName = chatDisplayName
                                self.recentMessages[j].lastMessageText = lastMessageText
                                self.recentMessages[j].read = read
                                self.recentMessages[j].timestamp = timestamp.dateValue()
                            }
                        }
                    }
                }
            }
        } else {
            print("No active user to get messages for")
        }
        
    }
    
    func recentMessageOnAppear(userId: String, handler: @escaping (_ lastMessageText: String?, _ read: Bool?, _ timestamp: Date?) -> ()) {
        if self.currentUserID != nil {
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
    }
    
    func updateRecentsOnRead (fromUserId: String, toUserId: String, read: Bool) {
        
        // Update From Recents
        self.db.collection("messages").document(fromUserId).collection("recents").document(toUserId).updateData(["read":read])
        
        // Update To Recents
        self.db.collection("messages").document(toUserId).collection("recents").document(fromUserId).updateData(["read":read])
        
        print("Success Reading Recent Message")

    }
    
}
