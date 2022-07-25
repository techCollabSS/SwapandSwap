//
//  SettingsView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/5/21.
//

import SwiftUI
import FirebaseFirestoreSwift

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var showSignOutError: Bool = false
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                //MARK: SECTION 1: SwApp
                GroupBox(label: SettingsLabelView(labelText: "Swap & Swap", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        
                        Image("logo.transparent")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                        
                        Text("Swap & Swap is a revolutionary social media platform that allows our users to have a dynamic closet by swapping with other users.")
                            .font(.footnote)
                            .accentColor(Color.MyTheme.DarkGreyColor)
                        
                    })
                })
                    .groupBoxStyle(PlainGroupBoxStyle())
                    .padding()
                
                //MARK: SECTION 2: PROFILE
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    NavigationLink(destination: SettingsEditTextView(submissionText: userDisplayName, title: "Display Name", description: "You can edit your display name here. This will be seen by other users on your profile and on your posts!", placeholder: "Your display name here....", settingsEditTextOption: .displayName, profileText: $userDisplayName), label: {
                        SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.DarkGreyColor)
                    })
                    
                    NavigationLink(destination: SettingsEditTextView(submissionText: userBio, title: "Profile Bio", description: "Your bio is a great place to let other users know a little about you. It will be shown on your profile only.", placeholder: "Your bio here....", settingsEditTextOption: .bio, profileText: $userBio), label: {
                        SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.DarkGreyColor)
                    })
                    
                    NavigationLink(destination: SettingsEditImageView(title: "Profile Picture", description: "Your profile picture will be shown on your prifle and on your posts. Most users make it an image of themselves with their clothing style!", selectedImage: userProfilePicture, profileImage: $userProfilePicture), label: {
                        SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.DarkGreyColor)
                    })
                    
                    Button(action: {
                        signOut()
                    }, label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.DarkGreyColor)
                    })
                        .alert(isPresented: $showSignOutError, content: {
                            return Alert(title: Text("Error Signing Out 🥵"))
                        })
                })
                    .groupBoxStyle(PlainGroupBoxStyle())
                    .padding()
                
                //MARK: SECTION 3: APPLICATION
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com") //INSERT SWAPP'S PRIVACY POLICY
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")  //INSERT SWAPP'S TERMS & CONDITIONS
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")  //INSERT SWAPP'S HOME PAGE WEBSITE
                    }, label: {
                        SettingsRowView(leftIcon: "globe", text: "Swap & Swap Website", color: Color.MyTheme.yellowColor)
                    })
                })
                    .groupBoxStyle(PlainGroupBoxStyle())
                    .padding()
                
                //MARK: SECTION 4: SIGN OFF
                GroupBox {
                    Text("Swap & Swap was made with love. \n All rights Reserved \n Swap & Swap LLC. \n Copyright 2021 ❤️")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .groupBoxStyle(PlainGroupBoxStyle())
                .padding()
                .padding(.bottom, 80)
                
            })
                .accentColor(Color.MyTheme.DarkGreyColor)
                .navigationBarTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(leading:
                                        Button(action: {
                                            presentationMode.wrappedValue.dismiss()
                                        }, label: {
                                            Image(systemName: "xmark")
                                                .font(.title)
                                        })
                    )
        }
        .accentColor(colorScheme == .light ? Color.MyTheme.DarkGreyColor : Color.MyTheme.yellowColor)
    }
    //MARK: FUNCTIONS
    
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        AuthService.instance.logOutUser { (success) in
            if success {
                print("SUCCESSFULLY LOGGED OUT")
                
                // Dissmiss settings view
                self.presentationMode.wrappedValue.dismiss()
            } else {
                print("ERROR LOGGING OUT")
                self.showSignOutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var testString: String = ""
    @State static var testimage: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        SettingsView(userDisplayName: $testString, userBio: $testString, userProfilePicture: $testimage)
            .preferredColorScheme(.dark)
    }
}
