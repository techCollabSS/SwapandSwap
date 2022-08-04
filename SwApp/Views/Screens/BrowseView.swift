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
    
    var posts:  PostArrayObject
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            //CarouselView(posts: posts)
            
            Text("Items to Swap")
                .multilineTextAlignment(.center)
                .padding()
            
            ImageGridView(posts: posts)
        })
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView(posts: PostArrayObject(shuffled: true))

        }
    }
}
