//
//  SwAppApp.swift
//  SwApp
//
//  Created by Juan Alvarez on 10/31/21.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import Firebase

@main
struct SwAppApp: App {
    
    init(){
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID // For Google Sign In
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance().handle(url) // For Google sign in
                })
        }
    }
}
