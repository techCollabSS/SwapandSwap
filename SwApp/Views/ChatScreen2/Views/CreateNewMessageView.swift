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
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
        
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // If user has a value, be String. If not, then nil. AppStorage is the SwiftUI version of calling user defaults.
    

    var body: some View {
        
        if currentUserID != nil {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    NewMessageUserRowView(user: user)
                }
            }

        }
    }
}
struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(vm: CreateMessageArrayObject())
    }
}
