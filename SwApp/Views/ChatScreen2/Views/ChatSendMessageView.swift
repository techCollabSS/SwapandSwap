//
//  ChatSendMessageView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/28/22.
//

import SwiftUI

struct ChatSendMessageView: View {
    
        
   // var messageArray = ["Hello you", "How are you", "I have been playing around with my PS5"]
    
    @State var toUserId: String?
    @State var toUserDisplayName: String?
            
    @StateObject var messagesService = MessagesService()
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?


    var body: some View {
        
        if currentUserID  != nil {
            VStack {
                VStack {
                    ChatTitleRowView(toUserId: toUserId!, toUserDisplayName: toUserDisplayName!)
                        .background(Color.MyTheme.whiteColor)
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(messagesService.messages, id: \.id) { message in
                                MessageBubbleView(message: message)
                            }
                        }
                        .padding(.top, 10)
                        .background(Color.MyTheme.whiteColor)
                        .cornerRadius(60, corners: [.topLeft, .topRight])
                        .onChange(of: messagesService.lastMessageId) { id in
                            withAnimation {
                                proxy.scrollTo(id, anchor: .bottom )
                            }
                        }
                    }
                }
                .background(Color.MyTheme.yellowColor)
                .onAppear {
                    messagesService.getMessages(fromUserId: currentUserID!, toUserId: toUserId!)
                }

                MessageField(toUserId: toUserId!, toUserDisplayName: toUserDisplayName!)
                        .environmentObject(MessagesService())
            }
        }
    }
}

struct ChatSendMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSendMessageView(toUserId: "test", toUserDisplayName: "test")
    }
}
