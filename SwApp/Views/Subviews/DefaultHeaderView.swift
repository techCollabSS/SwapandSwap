//
//  DefaultHeaderView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct DefaultHeaderView: View {
        
    var profileUserID: String
        
    @Binding  var isShowing: Bool
    
    @Binding var postSearchData : [PostModel]
    
    @Binding var searchText: String
        
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!

    var body: some View {
      
            HStack {
                // Search Portion
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                
                ZStack {
                    
                RoundedRectangle(cornerRadius: 10)
                        .fill(Color.MyTheme.yellowColor.opacity(0.24))
                    
                    HStack {
                        TextField("Search", text: $searchText)
                                .padding(.leading, 20)
                            if self.searchText != ""{
                                
                                Button(action: {
                                    
                                    self.searchText = ""
                                    
                                }) {
                                    
                                    Text("Cancel")
                                        .foregroundColor(Color.MyTheme.DarkGreyColor)
                                        .fontWeight(.semibold)
                                        .padding(.trailing, 10)
                                }
                                
                            }
                    }
                                                            
                //MARK: DELETE MARK
                Spacer()
                
            }
                .padding(.leading, 5)
                
                ZStack{
                    if let userID = currentUserID, let displayName = currentUserDisplayName {
                        
                        Button {
                            isShowing = true
                            
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color.MyTheme.orangeColor)
                                .font(Font.system(size: 25, weight: .bold))
                        }

                    } else {
                        NavigationLink(
                            destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                                SignUpView()
                            }),
                            label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(Color.MyTheme.orangeColor)
                            })
                    }
                }
            }
            .frame(height: 36)
            .padding()
        
        
    }
    
    // MARK: FUNCTIONS
    
    func getProfileImage() {
        if currentUserID != nil {

        ImageManager.instance.downloadProfileImage(userID: profileUserID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
}
//    func getAdditionalProfileInfo() {
//        if currentUserID != nil {
//            AuthService.instance.getUserInfo(forUserID: profileUserID) { (returnedDisplayName, returnedBio) in
//                if let displayName = returnedDisplayName {
//                    self.profileDisplayName = displayName
//                }
//            }
//
//        }
//    }
}

struct DefaultHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
            .preferredColorScheme(.dark)
    }
}
