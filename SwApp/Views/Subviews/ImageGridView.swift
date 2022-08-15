//
//  ImageGridView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var posts: PostArrayObject
    
  //  @State var post: PostModel?

    
    var body: some View {
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
                ForEach(posts.dataArray, id: \.self) { post in
                    NavigationLink(
                        destination: FeedView(posts: PostArrayObject(post: post), title: "Post", reload: false, showHeader: false),
                        label: {
                            PostView(post: post, showHeaderAndFooter: false, addHeartAnimationToView: false, defaultPadding: false)
                        })
                }
            })
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var post: PostModel = PostModel(postID: "", userID: "", username: "Joe Green", postCategory: "Test", caption: "This is a test caption", dateCreated: Date(), likeCount: 0, likedByUser: false)

    static var previews: some View {
        ImageGridView(posts: PostArrayObject(shuffled: true))
            .previewLayout(.sizeThatFits)
    }
}
