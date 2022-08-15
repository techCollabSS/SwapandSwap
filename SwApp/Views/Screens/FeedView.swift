//
//  FeedView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/1/21.
//

import SwiftUI


struct FeedView: View {
    
    @State var isShowing = false

    @State var searchText = ""
    
    @ObservedObject var posts: PostArrayObject
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var title: String
    var reload: Bool? = true
    
    @State var showHeader: Bool? = true
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
 
                        VStack {
                            if showHeader == true {
                                if let userID = currentUserID, let displayname = currentUserDisplayName {
                                    VStack{
                                        DefaultHeaderView(profileUserID: userID,
                                                          isShowing: $isShowing,
                                                          postSearchData: $posts.dataArray,
                                                          searchText: $searchText)
                                    }
                                } else{
                                    VStack{
                                        DefaultHeaderView(profileUserID: "",
                                                          isShowing: $isShowing,
                                                          postSearchData: $posts.dataArray,
                                                          searchText: $searchText)
                                    }
                                }
                            }

                            if self.searchText != ""{
                                
                                if posts.dataArray.filter({$0.username.lowercased().contains(self.searchText.lowercased()) || $0.postCategory.lowercased().contains(self.searchText.lowercased()) }).count == 0 {
                                    
                                    Text("No Results Found").padding(.top, 10)
                                }
                                
                                else {
                                    ForEach(posts.dataArray.filter({$0.username.lowercased().contains(self.searchText.lowercased()) || $0.postCategory.lowercased().contains(self.searchText.lowercased())}),id: \.self){ post in
                                        PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true)
                                    }
                                }
                            } else {
                                ForEach(posts.dataArray,id: \.self) { post in
                                    
                                    PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true)
                                }
                            }
                            

                        }
                })
                .blur(radius: isShowing == true ? 5 : 0)
                .navigationBarTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    reloadFeed(reload: reload!)
                    isShowing = false
                }
                
                if isShowing == true {
                        VStack {
                            CustomActionSheetView(isShowing: $isShowing)
                        }
                        .animation(.default)
                        .edgesIgnoringSafeArea(.bottom)
                    }
            }
                .onTapGesture {
                    isShowing = false
                }
            }
            .background(Color.MyTheme.beigeColor)
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
