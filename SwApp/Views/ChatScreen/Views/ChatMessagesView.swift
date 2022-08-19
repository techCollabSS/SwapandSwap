//
//  MessagesView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct ChatMessagesView: View {
            
    @EnvironmentObject var recentMessageService: RecentMessagesService
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    @State var showSheet = false
    @State var showChat = false
    @State var chatUserId = ""
    @State var chatUserDisplayName = ""

    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    let usersModel = CreateMessageArrayObject()
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination:
                            ChatSendMessageView(toUserId: self.chatUserId, toUserDisplayName: self.chatUserDisplayName), isActive: self.$showChat) {
                
                Text("")
            }
            
            VStack {
                ScrollView (.vertical, showsIndicators: false) {
            
//                VStack {
//                    ForEach(recentMessageService.recentMessages.sorted(by: {$0.timestamp > $1.timestamp})) { message in
//                        RecentMessagesView(chatUserId: message.chatUserId, chatDisplayName: message.chatDisplayName, chatLastMessageText: message.lastMessageText, messageTimeStamp: message.timestamp)
//
//                    }
//                }
            
            VStack(spacing: 12){
                
                ForEach(recentMessageService.recentMessages.sorted(by: {$0.timestamp > $1.timestamp})){ message in
                    
                    Button(action: {
                        
                        self.chatUserId = message.chatUserId
                        self.chatUserDisplayName = message.chatDisplayName
                        self.showChat.toggle()
                        
                    }) {
                        
                        RecentMessagesView(chatUserId: message.chatUserId, chatDisplayName: message.chatDisplayName, chatLastMessageText: message.lastMessageText, messageTimeStamp: message.timestamp)
                    }
                    
                }
                
            }.padding()
        }
        .navigationBarTitle("Recent Messages")

            newMessageButton

        }
        .sheet(isPresented: self.$showSheet) {
            NavigationView {
                CreateNewMessageView(showSheet: $showSheet, showChat: $showChat, chatUserId: self.$chatUserId, chatUserDisplayName: self.$chatUserDisplayName)
                    .navigationBarTitle("New Message")
            }
        }
    }
}
    
    
    private var newMessageButton: some View {
        Button(action: {
            self.showSheet.toggle()

            }, label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.MyTheme.orangeColor)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        })
        .padding(.bottom, 20)
    }
    
    // MARK: FUNCTIONS
    
    
}
struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView()
            .preferredColorScheme(.dark)
    }
}
