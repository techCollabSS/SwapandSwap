//
//  OnboardingView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/7/21.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2: Bool = false
    @State var showError: Bool = false
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
            
            Text("Welcome to Swap & Swap!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.whiteColor)
            
            Text("SwApp is a revolutionary social media platform that allows our users to have a dynamic closet by swapping with other users.")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.whiteColor)
                .padding()
            
            //MARK: SIGN IN WITH APPLE
            Button(action: {
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)
            }, label: {
                signInWithAppleButtonCustom()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            })
            
            //MARK: SIGN IN WITH GOOGLE
            Button(action: {
                SignInWithGoogle.instance.startSignInWithGoogleFlow(view: self)
            }, label: {
                HStack {
                    
                    Image(systemName: "globe") // TO DO: INSERT GOOGLE LOGO
                    
                    Text("Sign in with Google")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                .cornerRadius(6)
                .font(.system(size: 23, weight: .medium, design: .default))
            })
                .accentColor(Color.white)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
            })
            .accentColor(Color.MyTheme.whiteColor)
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboardingPart2, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            OnboardingViewPart2(displayName: $displayName, email: $email, providerID: $providerID, provider: $provider)
        })
        .alert(isPresented: $showError, content: {
            return Alert(title: Text("Error signin in 😢"))
        })
        .background(PlayerView())
        .edgesIgnoringSafeArea(.all)
    }

    
    //MARK: FUNCTIONS
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.logInUserToFirebase(credential: credential) { (returnedProviderID, isError, isNewUser, returnedUserID)  in
            
            if let newUser = isNewUser {
                
                if newUser {
                    // NEW USER
                    if let providerID = returnedProviderID, !isError {
                        // New user, continue to the onboarding part 2
                        self.displayName = name
                        self.email = email
                        self.providerID = providerID
                        self.provider = provider
                        self.showOnboardingPart2.toggle()
                        
                    } else {
                        // ERROR
                        print("ERROR GETTING PROVIDER ID FROM LOGGING USER TO FIREBASE")
                        self.showError.toggle()
                    }
                    
                } else {
                    // EXISTING USER
                    if let userID = returnedUserID {
                        // SUCCESS, LOG IN TO APP
                        AuthService.instance.logInUserToApp(userID: userID) { (success) in
                            
                            if success {
                                print("SUCCESS LOGGING EXISTNG USER")
                                self.presentationMode.wrappedValue.dismiss()
                                
                            } else {
                                print("Error logging existing user into our app")
                                self.showError.toggle()
                            }
                        }
                        
                    } else {
                        // ERROR
                        print("Error getting USER ID from existing user to Firebase") // NOTE: This should never happen, but its there just in case.
                        self.showError.toggle()
                    }
                }
                
            } else {
                // ERROR
                print("Error getting into from log in user to Firebase")
                self.showError.toggle()
            }
        
            
            
            
        }
        
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            
    }
}
