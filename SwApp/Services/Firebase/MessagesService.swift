//
//  MessagesService.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/28/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesService: ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
        
    @State var toUserId: String?

    @Published private(set) var messages: [MessageModel] = []
    
    @Published private(set) var recentMessages: [RecentMessageModel] = []
    
    @Published private(set) var lastMessageId = ""
    
    @Published private(set) var lastMessageText = ""

    

    private var REF_MESSAGES = DB_BASE.collection("messages")
    
    let db = Firestore.firestore()
    
    
    init() {
        
        if currentUserID != nil {
        
            if let fromUserId = currentUserID, let toUserId = toUserId {
                
                getMessages(fromUserId: fromUserId, toUserId: toUserId)
            }
        }
    }
    
    
    
    // MARK: GET FUNCTIONS
    
    func getMessages(fromUserId: String, toUserId: String ) {
        
        if currentUserID != nil {
            db.collection("messages").document(fromUserId).collection(toUserId).addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching messages documents: \(String(describing: error))")
                    return
                }
                
                self.messages = documents.compactMap { document -> MessageModel? in
                    do {
                        return try document.data(as: MessageModel.self)
                    } catch {
                        print("Error decoding message document into MessageModel: \(error) ")
                        return nil
                    }
                }
                
                self.messages.sort {$0.timestamp < $1.timestamp } // sort messages by timestamp
                
                if let id = self.messages.last?.id {
                    self.lastMessageId = id
                }
            }
        }
    }
    
    // MARK: ADD FUNCTIONS

    func sendMessage(text: String, fromUserId: String, fromDisplayName: String,toUserId: String, toDisplayName: String) {
        
        // Set the Sender Message in database
        do {
            
            let newFromMessage = MessageModel(fromUserId: fromUserId,
                                              fromDisplayName: fromDisplayName,
                                              toUserId: toUserId,
                                              toDisplayName: toDisplayName,
                                              id: "\(UUID())",
                                              messageText: text,
                                              received: false,
                                              timestamp: Date())
            
            let fromDocument = REF_MESSAGES.document(fromUserId).collection(toUserId).document()

            try fromDocument.setData(from: newFromMessage)
            
           print("Succefully Added From Message to Firestore")
            
        } catch {
            print("Error adding From message to Firestore: \(error)")
        }
        
        // Set the receiver message in database
        do {
            
            let newToMessage = MessageModel(fromUserId: fromUserId,
                                            fromDisplayName: fromDisplayName,
                                            toUserId: toUserId,
                                            toDisplayName: toDisplayName,
                                            id: "\(UUID())",
                                            messageText: text,
                                            received: true,
                                            timestamp: Date())
            
            let toDocument = REF_MESSAGES.document(toUserId).collection(fromUserId).document()

            try toDocument.setData(from: newToMessage)
            
            print("Succefully Added TO Message to Firestore")
            
        } catch {
            print("Error adding TO message to Firestore: \(error)")
        }
        
        setRecents(text: text,
                   fromUserId: fromUserId,
                   fromDisplayName: fromDisplayName,
                   toUserId: toUserId,
                   toDisplayName: toDisplayName)
    }
    
    func setRecents (text: String, fromUserId: String, fromDisplayName: String,toUserId: String, toDisplayName: String) {
        
        db.collection("messages").document(toUserId).collection("recents").document(fromUserId).getDocument { (snap, err) in
            
            if !snap!.exists {
                
                // Set Sender Recent Messages in Database
                do {
                    
                    let recentFromMessage = RecentMessageModel(id: "\(UUID())",
                                                               chatUserId: toUserId,
                                                               chatDisplayName: toDisplayName,
                                                               lastMessageText: text,
                                                               read:true,
                                                               timestamp: Date())
                    
                    let fromDocument = self.REF_MESSAGES.document(fromUserId).collection("recents").document(toUserId)

                    try fromDocument.setData(from: recentFromMessage)
                    
                    print("Succefully Added Recent From Message to Firestore")
                    
                } catch {
                    print("Error adding Recent From Message to Firestore: \(error)")
                }
                
                
                // Set Receiver Recent Messages in Database
                do {
                    
                    let recentToMessage = RecentMessageModel(id: "\(UUID())",
                                                             chatUserId: fromUserId,
                                                             chatDisplayName: fromDisplayName,
                                                             lastMessageText: text,
                                                             read:false,
                                                             timestamp: Date())

                    let toDocument = self.REF_MESSAGES.document(toUserId).collection("recents").document(fromUserId)

                    try toDocument.setData(from: recentToMessage)
                    
                    print("Succefully Added Recent TO Message to Firestore")
                    
                } catch {
                    print("Error adding Recent TO Message to Firestore: \(error)")
                }
            } else {
                self.updateRecents(text: text,
                                   fromUserId: fromUserId,
                                   fromDisplayName: fromDisplayName,
                                   toUserId: toUserId,
                                   toDisplayName: toDisplayName)
            }
        }
    }
    
    func updateRecents (text: String, fromUserId: String, fromDisplayName: String,toUserId: String, toDisplayName: String) {
        
        // Update From Recents
        self.db.collection("messages").document(fromUserId).collection("recents").document(toUserId).updateData(["lastMessageText":text,
                                                                                                                 "timestamp":Date()])
        
        // Update To Recents
        self.db.collection("messages").document(toUserId).collection("recents").document(fromUserId).updateData(["lastMessageText":text,
                                                                                                                 "timestamp":Date()])
        
        if let lastMessageText = self.recentMessages.last?.lastMessageText {
            self.lastMessageText = lastMessageText
        }
    }
}
