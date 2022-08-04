//
//  MainMessagesView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Brian Voong on 11/13/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift
    

struct MainMessagesView: View {
     
    var errorMessage = ""
    var isUserCurrentlyLoggedOut = false
    
    var profileUserID: String
    
    @State var profileDisplayName: String
    @State var profileBio: String = ""
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var message: ChatMessagesDataModel?
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserId: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName: String?
    
    
    @State var shouldShowLogOutOptions = false
    
    @State var shouldNavigateToChatLogView = false
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                //customNavBar
                //messagesView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                   // ChatLogView()
                }
            }
            //.overlay(
               // newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
//    private var customNavBar: some View {
//        HStack(spacing: 16) {
//
//            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
//                .resizable()
//                .scaledToFill()
//                .frame(width: 50, height: 50)
//                .clipped()
//                .cornerRadius(50)
//                .overlay(RoundedRectangle(cornerRadius: 44)
//                            .stroke(Color(.label), lineWidth: 1)
//                )
//                .shadow(radius: 5)
//
//
//            VStack(alignment: .leading, spacing: 4) {
//                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
//                Text(email)
//                    .font(.system(size: 24, weight: .bold))
//
//                HStack {
//                    Circle()
//                        .foregroundColor(.green)
//                        .frame(width: 14, height: 14)
//                    Text("online")
//                        .font(.system(size: 12))
//                        .foregroundColor(Color(.lightGray))
//                }
//
//            }
//
//            Spacer()
//            Button {
//                shouldShowLogOutOptions.toggle()
//            } label: {
//                Image(systemName: "gear")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(Color(.label))
//            }
//        }
//        .padding()
//        .actionSheet(isPresented: $shouldShowLogOutOptions) {
//            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
//                .destructive(Text("Sign Out"), action: {
//                    print("handle sign out")
//                    vm.handleSignOut()
//                }),
//                    .cancel()
//            ])
//        }
//        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
//            LoginView(didCompleteLoginProcess: {
//                self.vm.isUserCurrentlyLoggedOut = false
//                self.vm.fetchCurrentUser()
//                self.vm.fetchRecentMessages()
//            })
//        }
//    }

//    private var messagesView: some View {
//        ScrollView {
//            ForEach(vm.recentMessages) { recentMessage in
//                VStack {
//                    Button {
//                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
//
//                        self.chatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageUrl: recentMessage.profileImageUrl)
//
//                        self.chatLogViewModel.chatUser = self.chatUser
//                        self.chatLogViewModel.fetchMessages()
//                        self.shouldNavigateToChatLogView.toggle()
//                    } label: {
//                        HStack(spacing: 16) {
//                            WebImage(url: URL(string: recentMessage.profileImageUrl))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 64, height: 64)
//                                .clipped()
//                                .cornerRadius(64)
//                                .overlay(RoundedRectangle(cornerRadius: 64)
//                                            .stroke(Color.black, lineWidth: 1))
//                                .shadow(radius: 5)
//
//
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text(recentMessage.username)
//                                    .font(.system(size: 16, weight: .bold))
//                                    .foregroundColor(Color(.label))
//                                    .multilineTextAlignment(.leading)
//                                Text(recentMessage.text)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(Color(.darkGray))
//                                    .multilineTextAlignment(.leading)
//                            }
//                            Spacer()
//
//                            Text(recentMessage.timeAgo)
//                                .font(.system(size: 14, weight: .semibold))
//                                .foregroundColor(Color(.label))
//                        }
//                    }
//
//
//
//                    Divider()
//                        .padding(.vertical, 8)
//                }.padding(.horizontal)
//
//            }.padding(.bottom, 50)
//        }
//    }
    
    @State var shouldShowNewMessageScreen = false
    
//    private var newMessageButton: some View {
//        Button {
//            shouldShowNewMessageScreen.toggle()
//        } label: {
//            HStack {
//                Spacer()
//                Text("+ New Message")
//                    .font(.system(size: 16, weight: .bold))
//                Spacer()
//            }
//            .foregroundColor(.white)
//            .padding(.vertical)
//                .background(Color.blue)
//                .cornerRadius(32)
//                .padding(.horizontal)
//                .shadow(radius: 15)
//        }
//        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
//            CreateNewMessageView(didSelectNewUser: { user in
//                print(user.email)
//                self.shouldNavigateToChatLogView.toggle()
//                self.chatUser = user
//                self.chatLogViewModel.chatUser = user
//                self.chatLogViewModel.fetchMessages()
//            })
//        }
//    }
    
    
    
    // MARK: FUNCTIONS
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: profileUserID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func getAdditionalProfileInfo() {
        AuthService.instance.getUserInfo(forUserID: profileUserID) { (returnedDisplayName, returnedBio) in
            if let displayName = returnedDisplayName {
                self.profileDisplayName = displayName
            }
            if let bio = returnedBio {
                self.profileBio = bio
            }
        }
    }
    
}

struct MainMessagesView_Previews: PreviewProvider {
    
    static let messages = ChatMessagesDataModel(messageID: "test", fromId: "test", toID: "test", displayName: "test", text: "test", timestamp: Date())

    static var previews: some View {
        MainMessagesView(profileUserID: "", profileDisplayName: "", message: messages)
    }
}

