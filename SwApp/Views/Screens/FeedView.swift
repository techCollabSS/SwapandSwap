//
//  FeedView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/1/21.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var posts: PostArrayObject
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var title: String
    
    var reload: Bool? = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack{
                if let userID = currentUserID, let displayname = currentUserDisplayName {
                    VStack{
                        DefaultHeaderView(profileUserID: userID, profileDisplayName: displayname)
                    }
                } else{
                    VStack{
                        DefaultHeaderView(profileUserID: "", profileDisplayName: "")
                    }
                }
                ForEach(posts.dataArray, id: \.self){ post in
                    PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true)
                }
            }
            
        })
        .background(Color.MyTheme.beigeColor.ignoresSafeArea(.all))
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            reloadFeed(reload: reload!)
            }
        }
    
    // MARK: FUNCTIONS
    
    
    func reloadFeed(reload: Bool) {

        if reload == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

             DataService.instance.downloadPostsForFeed { (returnedPosts) in

             posts.dataArray = returnedPosts

                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView(posts: PostArrayObject(shuffled: false), title: "Feed Test")
        }
    }
}
