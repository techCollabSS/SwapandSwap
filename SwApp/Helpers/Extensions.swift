//
//  Extensions.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/1/21.
//

import Foundation
import SwiftUI

extension Color {
    
    struct MyTheme {
        
        static var purpleColor:Color {
            return Color("ColorPurple")
        }
        
        static var yellowColor:Color {
            return Color("ColorYellow")
        }
        
        static var beigeColor:Color {
            return Color("ColorBeige")
        }
        
        static var whiteColor:Color {
            return Color("ColorWhite")
        }
        
        static var GreyColor:Color {
            return Color("ColorGrey")
        }
        
        static var DarkGreyColor:Color {
            return Color("ColorDarkGrey")
        }
        
        static var orangeColor:Color {
            return Color("ColorOrange")
        }
        
        static var lightBlueColor:Color {
            return Color("ColorLightBlue")
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
