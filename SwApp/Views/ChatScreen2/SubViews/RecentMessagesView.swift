//
//  RecentMessagesView.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/2/22.
//

import SwiftUI

struct RecentMessagesView: View {
        
    @State var recentMessage: RecentMessageModel
    
    @StateObject var recentMessageService = RecentMessagesService()
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?

    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var body: some View {

                    NavigationLink(
                        destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                            ChatSendMessageView(toUserId: recentMessage.chatUserId, toUserDisplayName: recentMessage.chatDisplayName)
                        }), label: {
                        HStack(spacing: 16) {
                            Image(uiImage:  profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.chatDisplayName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.leading)
                                Text(recentMessage.lastMessageText)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            
                            Text("\(recentMessage.timestamp.formatted(.dateTime.hour().minute()))")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                        .padding(.horizontal)

                    })
                    .padding(.vertical, 20)
                    .onAppear() {
                        getProfileImage()
                    }
                    Divider()

    }
  
    //MARK: FUNCTIONS
    
    func getProfileImage() {

        // Get profile image
        // NOTE: Sames as ProfileView
        ImageManager.instance.downloadProfileImage(userID: recentMessage.chatUserId) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    
    static var recentMessageModel: RecentMessageModel = RecentMessageModel(id: "", chatUserId: "", chatDisplayName: "", lastMessageText: "", timestamp: Date())

    static var previews: some View {
        RecentMessagesView(recentMessage: recentMessageModel)
    }
}
