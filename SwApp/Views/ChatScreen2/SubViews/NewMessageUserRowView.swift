//
//  NewMessageUserRowView.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/1/22.
//

import SwiftUI

struct NewMessageUserRowView: View {
    
    @State var user: UserModel
    
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    

    var body: some View {

        NavigationLink(
            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                ChatSendMessageView(toUserId: user.userID, toUserDisplayName: user.displayName)
            }), label: {
            HStack(spacing: 16) {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.label), lineWidth: 2)
                    )
                Text(user.displayName)
                    .foregroundColor(Color(.label))
                Spacer()
            }
            .padding(.horizontal)

        })
        .navigationBarTitle("New Message")
        .onAppear() {
            getProfileImage()
        }
        
        Divider()
            .padding(.vertical, 8)
        
    }
    
    // MARK: FUNCTIONS
    
    func getProfileImage() {

        // Get profile image
        // NOTE: Sames as ProfileView
        ImageManager.instance.downloadProfileImage(userID: user.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
}

struct NewMessageUserRowView_Previews: PreviewProvider {
    
    static var userModel: UserModel = UserModel(id: "", displayName: "", email: "", providerID: "", provider: "", userID: "", bio: "", dateCreated: Date())

    static var previews: some View {
        NewMessageUserRowView(user: userModel)
    }
}
