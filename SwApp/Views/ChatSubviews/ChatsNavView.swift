//
//  ChatsNavView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct  ChatsNavView: View {
    let outgoingMessaageBubble = Color.MyTheme.lightBlueColor
    let incomingMessaageBubble = Color.MyTheme.yellowColor
    let accentPrimary = Color.MyTheme.lightBlueColor
    
    var body: some View {

                VStack(alignment: .center, spacing: 2, content: {
                    HStack {
                        Image("amos")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
                    }
                    HStack(spacing: 4) {
                        Text("Amos")
                            .font(.caption2)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8))
                    }
                    
                })
        
                Divider()

            }

struct  ChatsNavView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsNavView()
            .preferredColorScheme(.dark)
    }
    }
}
