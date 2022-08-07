//
//  MessageBubbleView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/28/22.
//

import SwiftUI

struct MessageBubbleView: View {
    
    var message: MessageModel
    @State private var showTime = false
    
    var body: some View {
        
        VStack(alignment: message.received ? .leading : .trailing){
            HStack{
                Text(message.messageText)
                    .padding()
                    .background(message.received ? Color.MyTheme.yellowColor : Color.MyTheme.GreyColor)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment:  message.received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                    .padding(message.received ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(. horizontal, 10)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubbleView(message: MessageModel(fromUserId: "Test", fromDisplayName: "Test", toUserId: "Test", toDisplayName: "Test", id: "Test", messageText: "Test", received: false, timestamp: Date()))
    }
}
