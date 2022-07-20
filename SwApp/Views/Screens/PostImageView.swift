//
//  PostImageView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/3/21.
//

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.presentationMode)var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var captionText: String = ""
    @Binding var imageSelected: UIImage
    
    @AppStorage(CurrentUserDefaults.userID) var currenUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    // Alert
    @State var showAlert: Bool = false
    @State var postUploadedSuccessfully: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                })
                    .accentColor(.primary)
                
                    Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                Image(uiImage: imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                
                TextField("Add you caption here...", text: $captionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .font(.headline)
                    .padding(.horizontal)
                    .autocapitalization(.sentences) // Capitalize the first letter of each word in the sentence
                    
                Button(action: {
                    postPicture()
                }, label: {
                    Text("Post Picture!".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                })
                    .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
            })
                .alert(isPresented: $showAlert) { () -> Alert in
                    getAlert()
                }
        })
    }
    
    //MARK: FUNCTIONS
    
    func postPicture(){
        print("POST PICTURE TO DATABASE HERE")
        guard let userID = currenUserID, let displayName = currentUserDisplayName else { // Makes sure there is data in the variables before proceeding
            print("Error gettting userID or displayName while posting image")
            return
        }
        
        DataService.instance.uploadPost(image: imageSelected, caption: captionText, displayName: displayName, userID: userID) { (success) in
            self.postUploadedSuccessfully = success
            self.showAlert.toggle()
            
        }
    }
    
    func getAlert() -> Alert {
        
        if postUploadedSuccessfully {
            
            return Alert(title: Text("Successfully uploaded post! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            
        } else {
            return Alert(title: Text("Error uploading post 😭"))
        }
    }
    
}

struct PostImageView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "dog1")!
    
    static var previews: some View {
        PostImageView( imageSelected: $image)
            .preferredColorScheme(.light)
    }
}