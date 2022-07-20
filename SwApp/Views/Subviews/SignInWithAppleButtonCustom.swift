//
//  SignInWithAppleButtonCustom.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/7/21.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct signInWithAppleButtonCustom: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}
