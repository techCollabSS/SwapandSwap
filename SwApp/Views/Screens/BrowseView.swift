//
//  BrowseView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import SwiftUI

struct BrowseView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    @ObservedObject var posts: PostArrayObject
    
    @State var isShowing = false
    @State var searchText = ""
    
    var body: some View {
        
    ZStack {
        VStack {
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
            
            
            ScrollView(.vertical, showsIndicators: false, content: {
                //CarouselView(posts: posts)
                
    //            Text("Items to Swap")
    //                .multilineTextAlignment(.center)
    //                .padding()
    
                if self.searchText != "" {
                    
                    if posts.dataArray.filter({$0.username.lowercased().contains(self.searchText.lowercased()) || $0.postCategory.lowercased().contains(self.searchText.lowercased()) }).count == 0 {
                        
                        Text("No Results Found").padding(.top, 10)
                    }
                    
                    else {
 
                            // MARK: REMINDER -> Go back to a way to handle this in the Image Grid View
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                alignment: .center,
                                spacing: nil,
                                pinnedViews: [],
                                content: {
                                    ForEach(posts.dataArray.filter({$0.username.lowercased().contains(self.searchText.lowercased()) || $0.postCategory.lowercased().contains(self.searchText.lowercased())}),id: \.self) { post in
                                        
                                        NavigationLink(
                                            destination: FeedView(posts: PostArrayObject(post: post), title: "Post", reload: false),
                                            label: {
                                                PostView(post: post, showHeaderAndFooter: false, addHeartAnimationToView: false, defaultPadding: false)
                                            })
                                    }
                                })
                    }
                } else {
                    //ForEach(posts.dataArray,id: \.self) { post in
                        
                        ImageGridView(posts: posts)
                        
                    
                }

            })
                .blur(radius: isShowing == true ? 5 : 0)
                .navigationTitle("Search Items")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    reloadFeed(reload: true)
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
    }
    
    func reloadFeed(reload: Bool) {

        if reload == true {
             DataService.instance.downloadPostsForFeed { (returnedPosts) in

             posts.dataArray = returnedPosts

            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView(posts: PostArrayObject(shuffled: true))

        }
    }
}
