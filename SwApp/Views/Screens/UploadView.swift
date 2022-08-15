//
//  UploadView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import SwiftUI
import UIKit

struct UploadView: View {
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var postCategory: String
    
    @State var showPostImageView: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                
                Button(action: {
                    sourceType = UIImagePickerController.SourceType.camera
                    showImagePicker.toggle()
                    
                }, label: {
                    Text("Take Photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.whiteColor)
                })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.MyTheme.orangeColor)
                
                Button(action: {
                    sourceType = UIImagePickerController.SourceType.photoLibrary
                    showImagePicker.toggle()
                    
                }, label: {
                    Text("Import Photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.lightBlueColor)
                })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.MyTheme.GreyColor)
            }
            .sheet(isPresented: $showImagePicker, onDismiss: segueToPostImageView, content: {
                ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? Color.MyTheme.whiteColor : Color.MyTheme.whiteColor)
            })
            
            
            Image("logo.transparent")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
                .fullScreenCover(isPresented: $showPostImageView, content: {
                    PostImageView(postCategory: postCategory, imageSelected: $imageSelected)
                        .preferredColorScheme(colorScheme)
                    
                })
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    //MARK: FUNCTIONS
    
    func segueToPostImageView() {
        if imageSelected != UIImage(named: "logo")! {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showPostImageView.toggle()
            
            }
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(postCategory: "")
            .preferredColorScheme(.light)
    }
}
