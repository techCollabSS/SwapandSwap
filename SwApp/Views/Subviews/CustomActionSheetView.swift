//
//  CustomActionSheetView.swift
//  SwApp
//
//  Created by Juan Alvarez on 8/10/22.
//

import SwiftUI

struct CustomActionSheetView: View {
    
    @Binding var isShowing: Bool

    var body: some View {
        
        
        VStack(spacing: 15) {
            NavigationLink(
                destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                    UploadView(postCategory: "Shirts")
                }), label: {
                    
                    HStack(spacing: 16) {
                       Image("swap.shirt")
                            .font(.title2)
                           .foregroundColor(Color.MyTheme.orangeColor)
                       
                        Text("Shirt")
                        
                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundColor(Color.MyTheme.orangeColor)
                   }

            })
            
            NavigationLink(
                destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                    UploadView(postCategory: "Pants")
                }), label: {
                    
                    HStack(spacing: 16) {
                       Image("swap.pants")
                            .font(.title2)
                           .foregroundColor(Color.MyTheme.orangeColor)
                       
                        Text("Pants")
                        
                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundColor(Color.MyTheme.orangeColor)
                   }
            })
            
            NavigationLink(
                destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                    UploadView(postCategory: "Shoes")
                }), label: {
                    
                    HStack(spacing: 16) {
                       Image("swap.shoe")
                        .font(.title2)
                           .foregroundColor(Color.MyTheme.orangeColor)
                       
                        Text("Shoes")
                        
                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundColor(Color.MyTheme.orangeColor)
                   }

            })
            
            NavigationLink(
                destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                    UploadView(postCategory: "Misc")
                }), label: {
                    
                    HStack(spacing: 16) {
                       Image("swap.misc")
                            .font(.title2)
                           .foregroundColor(Color.MyTheme.orangeColor)
                       
                        Text("Accesories")
                        
                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundColor(Color.MyTheme.orangeColor)
                   }
            })
        }
        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
        .padding(.top,20)
        .background(Color.MyTheme.lightBlueColor)
        .cornerRadius(25)
        .animation(.default)
    }
}

struct CustomActionSheetView_Previews: PreviewProvider {
    @State var showActionSheet: Bool  = false

    static var previews: some View {
        SearchBarView()
            .preferredColorScheme(.dark)
    }
}
