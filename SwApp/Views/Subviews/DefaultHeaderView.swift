//
//  DefaultHeaderView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct DefaultHeaderView: View {
        
    var profileUserID: String
    
    let usersModel = CreateMessageArrayObject()
    
    let recentMessages = RecentMessagesService()

    @State var profileDisplayName: String
    
    @State private var search: String = ""
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!

    var body: some View {
      
            HStack {
                // Search Portion
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                
                ZStack {
                    
                RoundedRectangle(cornerRadius: 10)
                        .fill(Color.MyTheme.yellowColor.opacity(0.24))
                    
                TextField("Search", text: $search)
                        .padding(.leading, 20)
                
                Spacer()
                
            }
                .padding(.leading, 5)
            
                ZStack{
                    if currentUserID != nil , currentUserID != nil {
                        NavigationLink(
                            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                                ChatMessagesView(recentMessageService: recentMessages)
                            }),
                            label: {
                                Image(systemName: "text.bubble.fill")
                                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                            })
                        
                    } else {
                        NavigationLink(
                            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                                SignUpView()
                            }),
                            label: {
                                Image(systemName: "text.bubble.fill")
                                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                            })
                    }
     
                }
                
                ZStack{
                    if let userID = currentUserID, let displayName = currentUserDisplayName {
                    NavigationLink(
                        destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                            ProfileView(isMyProfile: true, profileUserID: userID, profileDisplayName: displayName, posts: PostArrayObject(userID: userID))
                        }),
                        label: {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30, alignment: .center)
                                .cornerRadius(15)
                        })
                            .onAppear(perform: {
                                getProfileImage()
                                getAdditionalProfileInfo()
                        })
                    } else {
                        NavigationLink(
                            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                                SignUpView()
                            }),
                            label: {
                                Image(systemName: "person.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                            })
                    }
                }
            }
            .frame(height: 36)
            .padding()
        
    }
    
    // MARK: FUNCTIONS
    
    func getProfileImage() {
        if currentUserID != nil {

        ImageManager.instance.downloadProfileImage(userID: profileUserID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
}
    func getAdditionalProfileInfo() {
        if currentUserID != nil {
            AuthService.instance.getUserInfo(forUserID: profileUserID) { (returnedDisplayName, returnedBio) in
                if let displayName = returnedDisplayName {
                    self.profileDisplayName = displayName
                }
            }
            
        }
    }
}

struct DefaultHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
            .preferredColorScheme(.dark)
    }
}
