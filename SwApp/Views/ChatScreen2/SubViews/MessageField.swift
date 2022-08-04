//
//  MessageField.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/28/22.
//

import SwiftUI

struct MessageField: View {
    
    @EnvironmentObject var messagesService: MessagesService
    @State private var message = ""
    
    @State var toUserId: String?
    @State var toUserDisplayName: String?

    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some View {
        
        if currentUserID != nil {
            
            HStack {
                CustomTexField(placeholder: Text("Write Message Here . . ."), messageText: $message)
                    .frame(height: 52)
                    .disableAutocorrection(true)
                
                Button {
                    if let fromUserId = currentUserID, let fromDisplayName = currentUserDisplayName {
                        messagesService.sendMessage(text: message, fromUserId: fromUserId, fromDisplayName: fromDisplayName, toUserId: toUserId!, toDisplayName: toUserDisplayName!)
                        message = ""
                        print("Message Sent!!")
                    }
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.MyTheme.whiteColor)
                        .padding(10)
                        .background(Color.MyTheme.yellowColor)
                        .cornerRadius(50)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.MyTheme.GreyColor)
            .cornerRadius(50)
            .padding()
        }
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField(toUserId: "")
            .environmentObject(MessagesService())
    }
}

struct CustomTexField: View {
    
    var placeholder: Text
    @Binding var messageText: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if messageText.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $messageText, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
