//
//  ProfileHeaderView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/5/21.
//

import SwiftUI

struct ProfileHeaderView: View {

    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    @Binding var profileBio: String
    @ObservedObject var postArray: PostArrayObject
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            
            //MARK: PROFILE PICTURE
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            //MARK: USER NAME
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            //MARK: BIO
            if profileBio != "" {
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            HStack(alignment: .center, spacing: 20, content: {
                
                //MARK: POST
                VStack(alignment: .center, spacing: 5, content: {
                    Text(postArray.postCountString) // Watches the count string
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                })
                
                //MARK: LIKES
                VStack(alignment: .center, spacing: 5, content: {
                    
                    Text(postArray.likeCountString) // Watches the count string
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                })
                
            })
        })
            .frame(maxWidth: .infinity)
            .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    
    @State static var name: String = "Joe"
    @State static var image: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image, profileBio: $name, postArray:  PostArrayObject(shuffled: false))
            .previewLayout(.sizeThatFits)
    }
}
