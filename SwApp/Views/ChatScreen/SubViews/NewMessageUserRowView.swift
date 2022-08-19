//
//  NewMessageUserRowView.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/1/22.
//

import SwiftUI

struct NewMessageUserRowView: View {
    
    //@State var user: UserModel
    
    @State var userId: String?
    @State var userDisplayName: String?
    
    @State private var search: String = ""

    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    @Binding var showSheet: Bool
    
    var body: some View {


            HStack(spacing: 16) {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.MyTheme.yellowColor, lineWidth: 2)
                    )
                Text(userDisplayName!)
                    .foregroundColor(Color(.label))
                Spacer()
            }
            .padding(.horizontal)
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
        ImageManager.instance.downloadProfileImage(userID: userId!) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
}

struct NewMessageUserRowView_Previews: PreviewProvider {
    
    static var userModel: UserModel = UserModel(id: "", displayName: "", email: "", providerID: "", provider: "", userID: "", bio: "", dateCreated: Date())

    static var previews: some View {
        SearchBarView()
        //NewMessageUserRowView()
    }
}
