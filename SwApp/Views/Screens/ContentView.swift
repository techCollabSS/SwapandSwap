//
//  ContentView.swift
//  SwApp
//
//  Created by Juan Alvarez on 10/31/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    let feedPosts = PostArrayObject(shuffled: false)
    let browsePosts = PostArrayObject(shuffled: true)


    var body: some View {
        TabView {
            NavigationView {
                FeedView(posts: feedPosts, title: "Home")
            }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            UploadView()
                .tabItem {
                    //Image(systemName: "square.and.arrow.up.fill")
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Post")
                }
            
            NavigationView {
                BrowseView(posts: browsePosts)
            }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            ZStack {
                // NOTE: This is to show the User Diplay under the profile info
                if let userID = currentUserID, let displayName = currentUserDisplayName {
                    NavigationView {
                        ProfileView(isMyProfile: true, profileUserID: userID, profileDisplayName: displayName, posts: PostArrayObject(userID: userID))
                    }
                } else {
                    SignUpView()
                    }
                }
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
            }
        }
        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
