//
//  RecentMessagesView.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/2/22.
//

import SwiftUI

struct RecentMessagesView: View {
        
    @State var recentMessage: RecentMessageModel
    
    @State var recentMessageText: String = ""
    
    @State var recentTimestamp: Date?
    
    @State var recentRead: Bool?
    
    
    
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?

    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var body: some View {

                    NavigationLink(
                        destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                            ChatSendMessageView(toUserId: recentMessage.chatUserId, toUserDisplayName: recentMessage.chatDisplayName).onAppear {
                                readRecentMessage(fromUserId: currentUserID!, toUserId: recentMessage.chatUserId, read: true)
                            }
                        }), label: {
                        HStack(spacing: 16) {
                            Image(uiImage:  profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color.MyTheme.yellowColor, lineWidth: 1))
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.chatDisplayName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.leading)
                            
                              if let recentMessageTextOne = recentMessageText  {
                                  
                                  if recentMessageTextOne.isEmpty {
                                      
                                      Text(recentMessage.lastMessageText)
                                              .font(.system(size: 14))
                                              .truncationMode(.tail)
                                              .lineLimit(1)
                                              .foregroundColor(Color.MyTheme.DarkGreyColor)
                                              .multilineTextAlignment(.leading)
                                      
                                  } else {
                                        Text(recentMessageText)
                                            .font(.system(size: 14))
                                            .truncationMode(.tail)
                                            .lineLimit(2)
                                            .foregroundColor(Color.MyTheme.DarkGreyColor)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            Spacer()
                            
                            
                            Text("\(recentMessage.timestamp.formatted(.dateTime.month().day(.twoDigits).hour(.conversationalDefaultDigits(amPM: .abbreviated)).minute(.twoDigits)))")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                        .padding(.horizontal)
                    })
                    .background(recentRead == true ? Color.MyTheme.whiteColor : Color.MyTheme.lightBlueColor)
                    .padding(.vertical, 20)
                    .onAppear(perform: {
                        getProfileImage()
                        reloadRecentMessages(userId: recentMessage.chatUserId)
                    })
                    
        Divider()
            .frame(height: 0.5)

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
    
    func  reloadRecentMessages(userId: String) {

            RecentMessagesService.instance.recentMessageOnAppear(userId: userId) { lastMessageText, read, timestamp in
                recentMessageText = lastMessageText!
                recentRead = read!
                recentTimestamp = timestamp
            
        }
    }
    
    func readRecentMessage (fromUserId: String, toUserId: String, read: Bool) {
        RecentMessagesService.instance.updateRecentsOnRead(fromUserId: fromUserId, toUserId: toUserId, read: read)
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    
    static var recentMessageModel: RecentMessageModel = RecentMessageModel(id: "", chatUserId: "", chatDisplayName: "", lastMessageText: "", read: false, timestamp: Date())

    static var previews: some View {
        RecentMessagesView(recentMessage: recentMessageModel)
    }
}
