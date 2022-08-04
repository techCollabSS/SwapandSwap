//
//  ChatBottomBar.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/27/22.
//

import SwiftUI

struct ChatBottomBar: View {
    
    
    @State var messagesArray = [ChatMessagesDataModel]()
    @State var messageText: String = ""
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserId: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName: String?
    
   @State var message: ChatMessagesDataModel
    
    
    // Alerts
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                HStack {
                    Text("Description")
                        .foregroundColor(Color(.gray))
                        .font(.system(size: 17))
                        .padding(.leading, 5)
                        .padding(.top, -4)
                    Spacer()
                }
                
                TextField("Write Message Here...", text: $messageText)
                        .opacity(messageText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                addComment()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    //MARK: FUNCTIONS
    
    func getProfilePicture()    {
        
        guard let userID = currentUserId else {return}
        
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            
            }
        
        }
    }

   func getMessage(){
        
        guard self.messagesArray.isEmpty else {return}
        print("GET COMMENTS FROM DATABASE")
       
       if let text = message.text, text.count > 1 {
           
           let messageText = ChatMessagesDataModel(messageID: "", fromId: message.fromId, toID: message.toID, displayName: message.displayName, text: text, timestamp: Date())
           self.messagesArray.append(messageText)
       }
       
       ChatService.instance.fetchMessages(fromID: message.fromId) { (returnedMessages) in
           self.messagesArray.append(contentsOf: returnedMessages)

       }
    }
    
    
    func addComment() {
        print("SENDING MESSAGE NOW")
//        guard let userID = currentUserId, let displayName = currentDisplayName else {return}
        
        ChatService.instance.uploadMessage(fromId: message.fromId, toId: message.toID, displayName: message.displayName, chatText: messageText, timestamp: Date()) {(success) in
            if success {
                let newMessage = ChatMessagesDataModel(messageID: message.messageID, fromId: message.fromId, toID: message.toID, displayName: message.displayName, timestamp: Date())
                self.messagesArray.append(newMessage)
                self.messageText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Takes the keyboard out after comment submission
                } else {
                    self.alertTitle =  "Message Error"
                    self.alertMessage = "There was an error uploading the message. Please restart the app and try again."
                    self.showAlert.toggle()
            }
        }
    }
}

struct ChatBottomBar_Previews: PreviewProvider {
    
    static let messages = ChatMessagesDataModel(messageID: "test", fromId: "test", toID: "test", displayName: "test", text: "test", timestamp: Date())
    
    static var previews: some View {
        ChatBottomBar(message: messages)
        }
    }
