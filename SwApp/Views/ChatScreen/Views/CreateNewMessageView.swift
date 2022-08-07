//
//  CreateNewMessageView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/31/22.
//

import SwiftUI

struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vm: CreateMessageArrayObject
    
    @State private var  viewModel = [UserModel]()
        
    @State private var search: String = ""
        
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    

    var body: some View {
        
        VStack {
            if currentUserID != nil {
                ScrollView {
                    Text(vm.errorMessage)
                    
//                    ForEach(vm.users) { user in
//                        NewMessageUserRowView(user: user)
//                    }
                    ForEach(filteredUsers!) { user in
                        NewMessageUserRowView(user: user)
                    }
                }
            }
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
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
    static var previews: some View {
        CreateNewMessageView(vm: CreateMessageArrayObject())
    }
}
