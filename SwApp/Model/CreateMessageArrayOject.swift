//
//  CreateMessagePostArrayOject.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/31/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class CreateMessageArrayObject: ObservableObject {
    
    @Published var errorMessage = ""
    
    @Published var empty = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    
    @Published var users = [UserModel]()
        
    let db = Firestore.firestore()
    
    init() {
        getAllUsers()
    }
    
    // MARK: GET FUNCTIONS
    
    func getAllUsers() {
        
        if self.currentUserID != nil {
            
        db.collection("users").getDocuments { (snap, err) in

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
                let displayName = i.get("display_name") as! String
                let email = i.get("email") as! String
                let providerID = i.get("provider_id") as! String
                let provider = i.get("provider") as! String
                let userID = i.get("user_id") as! String
                let bio = i.get("bio") as! String
                let dateCreated = i.get("date_created") as! Timestamp
                
                if id != self.currentUserID! {
                    
                    self.users.append(UserModel(id: id,
                                                displayName: displayName,
                                                email: email,
                                                providerID: providerID,
                                                provider: provider,
                                                userID: userID,
                                                bio: bio,
                                                dateCreated: dateCreated.dateValue()))
                    }
                }
            
            if self.users.isEmpty{
                
                self.empty = true
                }
            }
        }
    }
}
