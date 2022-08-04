//
//  ChatLogView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/27/22.
//

import SwiftUI

struct ChatLogView: View {
    
    @State var message: ChatMessagesDataModel

        
    var body: some View {
        ZStack {
          //  MessagesView(message: message)
//            Text(vm.errorMessage)
        }
//        .navigationTitle(vm.chatUser?.email ?? "")
//        .navigationBarTitleDisplayMode(.inline)
//        .onDisappear {
//            vm.firestoreListener?.remove()
        }
    }

    
struct ChatLogView_Previews: PreviewProvider {
    static let messages = ChatMessagesDataModel(messageID: "test", fromId: "test", toID: "test", displayName: "test", text: "test", timestamp: Date())

    static var previews: some View {
        ChatLogView(message: messages)
    }
}
