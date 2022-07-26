//
//  ComposeAreaView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

import SwiftUI

struct   ComposeAreaView: View {
    let outgoingMessaageBubble = Color.MyTheme.lightBlueColor
    let incomingMessaageBubble = Color.MyTheme.yellowColor
    let accentPrimary = Color.MyTheme.lightBlueColor
    
    @State private var write: String = ""
    
    
    var body: some View {
        HStack {
            Image(systemName: "camera.fill")
                .font(.title)
            Image("store")
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .stroke()
                HStack{
                    TextField("Write a message", text: $write)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "waveform.circle.fill")
                        .font(.title)
                }
                .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 3))
            }
            .frame(width: 249, height: 33)
        }
        .foregroundColor(Color(.systemGray))
    }
}

struct   ComposeAreaView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeAreaView()
            .preferredColorScheme(.dark)
    }
}
