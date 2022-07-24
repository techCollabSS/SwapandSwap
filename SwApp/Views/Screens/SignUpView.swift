//
//  SignUpView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/6/21.
//

import SwiftUI
import AVKit
import AVFoundation

struct SignUpView: View {
    
    @State var showOnboarding: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            
            Spacer()
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("You're not signed in! 🙁")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.MyTheme.whiteColor)
            
            Text("Click the button below to create an account and join the fun!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.whiteColor)
            
            Button(action: {
                showOnboarding.toggle()
            }, label: {
                Text("Sign in / Sign up".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.MyTheme.orangeColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)
            })
            .accentColor(Color.MyTheme.whiteColor)
            
            Spacer()
            Spacer()
            
        })
        .padding(.all, 40)
        .background(PlayerView())
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView()
        })
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
