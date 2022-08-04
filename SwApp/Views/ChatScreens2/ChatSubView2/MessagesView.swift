//
//  MessagesView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/27/22.
//

import SwiftUI

struct MessagesView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserId: String?
    var chatMessages = [ChatMessagesDataModel]()
    
    static let emptyScrollToString = "Empty"

    var body: some View {
        
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(chatMessages) { message in
                                MsgView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(ChatService.instance.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                   // ChatBottomBar(message: chatMessages)
                        //.background(Color(.systemBackground).ignoresSafeArea())
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct MsgView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserId: String?
    
    let message: ChatMessagesDataModel
    
    var body: some View {
        VStack {
            if message.fromId == currentUserId {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text!)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text!)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct MessagesView_Previews: PreviewProvider {
    
    static let messages = ChatMessagesDataModel(messageID: "test", fromId: "test", toID: "test", displayName: "test", text: "test", timestamp: Date())

    static var previews: some View {
        MessagesView()
    }
}
