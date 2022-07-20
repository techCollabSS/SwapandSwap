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
    @State var profileDisplayName: String
    var profileUserID: String
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var posts: PostArrayObject
    
    @State var showSettings: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
        
            VStack{
                ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, postArray: posts)
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
            })
            .sheet(isPresented: $showSettings, content: {
                SettingsView()
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileDisplayName: "Joe", profileUserID: "", posts: PostArrayObject(userID: ""))
        }
        .preferredColorScheme(.dark)
        
    }
}
