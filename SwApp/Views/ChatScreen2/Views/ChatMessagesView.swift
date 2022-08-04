//
//  MessagesView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct ChatMessagesView: View {
        
    @State var shouldShowLogOutOptions = false
    @State private var score = 0
    
    @StateObject var recentMessageService: RecentMessagesService
    
    let usersModel = CreateMessageArrayObject()

    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    var body: some View {
        
        ScrollView {
            
            VStack {

                    ForEach(recentMessageService.recentMessages) { message in
                        RecentMessagesView(recentMessage: message)
                            .environmentObject(RecentMessagesService())


                }
            }

        }
        .navigationBarTitle("Recent Messages")
        newMessageButton

    }
    
    
    private var newMessageButton: some View {
        NavigationLink(
            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                 CreateNewMessageView(vm: usersModel)
            }), label: {
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
}
struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(recentMessageService: RecentMessagesService())
            .preferredColorScheme(.dark)
    }
}
