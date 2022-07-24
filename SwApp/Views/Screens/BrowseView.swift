//
//  BrowseView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import SwiftUI

struct BrowseView: View {
    
    var posts:  PostArrayObject
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            CarouselView(posts: posts)
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
