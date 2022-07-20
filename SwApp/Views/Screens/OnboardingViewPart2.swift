//
//  OnboardingViewPart2.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/7/21.
//

import SwiftUI

struct OnboardingViewPart2: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var provider: String
    
    @State var showImagePicker: Bool = false
    
    // For image picker
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .foregroundColor(.black)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0))
            
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker, onDismiss: createProfile, content: {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        })
        .alert(isPresented: $showError) { () -> Alert in
            return Alert(title: Text("Error creating profile 😤"))
        }
        
    }
    
    // MARK: FUNCTIONS
    
    func createProfile() {
        print("CREATE PROFILE NOW")
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerID: providerID, provider: provider, profileImage: imageSelected) { (returnedUserID) in
            
            if let userID = returnedUserID {
                // SUCCESS
                print("SUCCESSFULLY CREATED NEW USER IN DATABASE.")
                
                AuthService.instance.logInUserToApp(userID: userID) { (success) in
                    if success {
                        print("USER LOGGED IN!")
                        // return to app
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                        
                    } else {
                        print("ERROR LOGGING IN")
                        self.showError.toggle()
                    }
                }
            } else {
                // ERROR
                print("ERROR CREATING USER IN DATABASE")
                self.showError.toggle()
            }
            
        }
        
    }
    
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    
    @State static var testString: String = "Test"
    
    static var previews: some View {
        OnboardingViewPart2(displayName: $testString, email: $testString, providerID: $testString, provider: $testString)
            
    }
}
