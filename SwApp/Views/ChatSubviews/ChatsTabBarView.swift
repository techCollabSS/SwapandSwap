//
//  ChatsTabBarView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct  ChatsTabBarView: View {
    let outgoingMessaageBubble = Color.MyTheme.lightBlueColor
    let tabBarBg = Color.MyTheme.yellowColor
    let accentPrimary = Color.MyTheme.lightBlueColor
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(width: .infinity, height: 80)
                .foregroundColor(tabBarBg.opacity(0.2))
                .ignoresSafeArea(.all)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    Image("photos")
                    Image("appstore")
                    Image("memoji")
                    Image("digital")
                    Image("fitness")
                    Image("store")
                    Image("time")
                    Image("touch")
                    Image("app")
                    Image("photos")
                }
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 0))
            }
            
        }
    }
}

struct  ChatsTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsTabBarView()
            .preferredColorScheme(.dark)
    }
}
