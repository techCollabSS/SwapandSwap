//
//  ProfileView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/5/21.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var isMyProfile: Bool
    var profileUserID: String 
    @State var profileDisplayName: String
    @State var profileBio: String = ""
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var posts: PostArrayObject
    
    @State var showSettings: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
        
            VStack{
                ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, profileBio: $profileBio, postArray: posts)
            }
                .background(Color.MyTheme.whiteColor)
                .cornerRadius(12)
                .padding()

            VStack {
                ImageGridView(posts: posts)
            }
            .background(Color.MyTheme.whiteColor)
            .cornerRadius(12)
            .padding()

        })
            .background(Color.MyTheme.beigeColor.ignoresSafeArea(.all))
            .navigationBarTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showSettings.toggle()
                
                                    }, label: {
                                        Image(systemName: "line.horizontal.3")
                                    })
                                    .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                                    .opacity(isMyProfile ? 1.0 : 0.0)
            )
            .onAppear(perform: {
                getProfileImage()
                getAdditionalProfileInfo()
                reloadProfilePosts()
            })
            .sheet(isPresented: $showSettings, content: {
                SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
                    .preferredColorScheme(colorScheme)
            })
    }
    
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
    
    
    func reloadProfilePosts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

         DataService.instance.downloadPostForUser(userID: profileUserID) { (returnedPosts) in

         posts.dataArray = returnedPosts

            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileUserID: "", profileDisplayName: "Joe", posts: PostArrayObject(userID: ""))
        }
        .preferredColorScheme(.dark)
        
    }
}
