//
//  CreateNewMessageView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/31/22.
//

import SwiftUI

struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vm = CreateMessageArrayObject()
    
    @State private var  viewModel = [UserModel]()
        
    @State private var search: String = ""
    
    @Binding var showSheet: Bool
    @Binding var showChat: Bool
    @Binding var chatUserId: String
    @Binding var chatUserDisplayName: String

        
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    

    var body: some View {
        
            
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if currentUserID != nil {
                    ScrollView {
                        Text(vm.errorMessage)
                        
    //                    ForEach(vm.users) { user in
    //                        NewMessageUserRowView(user: user)
    //                    }
                        ForEach(filteredUsers!) { user in
                            
                            Button(action: {
                                
                                self.chatUserId = user.userID
                                self.chatUserDisplayName = user.displayName
                                self.showSheet.toggle()
                                self.showChat.toggle()
                                
                                
                            }) {
                                
                                NewMessageUserRowView(userId: user.userID, userDisplayName: user.displayName, showSheet: $showSheet)
                                }
                            }
                        }
                    }
                }
            }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarItems(leading:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.title)
                                        .foregroundColor(Color.MyTheme.orangeColor)
                                })
            )
    }
    
    var filteredUsers: [UserModel]? {

        if search.isEmpty {
            return vm.users
        } else {
            return vm.users.filter { $0.displayName.localizedStandardContains(search) }
        }

    }
}
struct CreateNewMessageView_Previews: PreviewProvider {
    
    @State var showSheet: Bool
    
    static var previews: some View {
        SearchBarView()
        //CreateNewMessageView(vm: CreateMessageArrayObject(), showSheet: $showSheet)
    }
}
