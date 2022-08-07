//
//  ChatTitleRowView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/28/22.
//

import SwiftUI

struct ChatTitleRowView: View {
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var toUserId: String?
    var toUserDisplayName: String?
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?

    var body: some View {
        
        if currentUserID != nil {
            HStack {
                
                NavigationLink(
                    destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                        ProfileView(isMyProfile: false, profileUserID: toUserId!, profileDisplayName: toUserDisplayName!, posts: PostArrayObject(userID: toUserId!))
                    }),label: {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                })
                VStack(alignment: .leading){
                    Text(toUserDisplayName!)
                        .font(.title.bold())
                    
//                            Text("Online")
//                            .font(.caption)
//                            .foregroundColor(Color.MyTheme.DarkGreyColor)
            }
                .frame(maxWidth: .infinity, alignment:  .leading)

                
//                Image(systemName: "phone.fill")
//                    .foregroundColor(Color.MyTheme.DarkGreyColor)
//                    .padding(10)
//                    .background(Color.MyTheme.whiteColor)
//                    .cornerRadius(50)
            }
            .padding()
            .onAppear {
                getProfileImage()
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    func getProfileImage() {
        
        // Get profile image
        // NOTE: Sames as ProfileView
        ImageManager.instance.downloadProfileImage(userID: toUserId!) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
}
}
    


struct ChatTitleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTitleRowView()
            .background(Color.MyTheme.yellowColor)
    }
}
