//
//  MessagesView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct ChatMessagesView: View {
    
    let outgoingMessaageBubble = Color.MyTheme.lightBlueColor
    let incomingMessaageBubble = Color.MyTheme.yellowColor
    let readIndicator = Color(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0))
    @State private var score = 0
    
    var messages: [MessagesStructure] = MessageData
    
    var body: some View {
        VStack {
            NavigationView {
                    // DefaultHeaderView(profileUserID: userID, profileDisplayName: displayname) IMPROVEMENT: Look for proper implementation later
                    SearchBarView()
                         .navigationTitle("Messages")
                         .navigationBarTitleDisplayMode(.inline)
                         .navigationBarItems(
                             leading:
                                 Button("Edit") {
                                     print("Pressed Edit")
                                     },
                             trailing:
                                 Button {
                                     print("start conversation")
                                 } label: {
                                     Image(systemName: "square.and.pencil")
                                 }
                         )
                
            }
            .frame(height: 80)
            
            Spacer()
            
            VStack {
                List(messages) { item in
                    
                    HStack {
                        NavigationLink(
                            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                                ChatsView()
                            }),
                            label: {
                                ZStack { // This helps to align the unread indicator, profile image and the text. Opacity of the color view is set to nil.
                                    readIndicator
                                        .frame(width: 11, height: 11)
                                    Image(item.unreadIndicator)
                                }
                                
                                Image(item.avatar)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 45, height: 45)
                                    
                                VStack(alignment: .leading){
                                        
                                    HStack{
                                        Text("\(item.name)")
                                        Spacer()
                                        HStack {
                                            Text("\(item.timestamp)")
                                                .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        }
                                    }
                                    Text("\(item.messageSummary)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            })
                        }
                    }
                } //LIST STYLES
                .listStyle(.plain)
        }
    }
}
struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(messages: MessageData)
            .preferredColorScheme(.dark)
    }
}
