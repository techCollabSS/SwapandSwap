//
//  ChatsView.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//

import SwiftUI

struct  ChatsView: View {
    
    let outgoingMessaageBubble = Color.MyTheme.lightBlueColor
    let incomingMessaageBubble = Color.MyTheme.yellowColor
    
    
    var body: some View {
        VStack{
          ChatsNavView()
            ScrollView(.vertical){
                // Consecutive incoming
                VStack(spacing: 2) {
                    Text("Mon 9. Aug, 20.35")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        IncomingDoubleLineMessage()
                        Spacer()
                    }
                    HStack {
                        IncomingDoubleLineMessage()
                        Spacer()
                    }
                }
                
                // Outgoing
                VStack(spacing: 2) {
                    Text("Tues 24. Aug, 20.25")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        OutgoingDoubleLineMessage()
                    }
                }
                
                // Incoming
                VStack(spacing: 2) {
                    Text("Fri 24. Aug, 15.17")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        IncomingTrippleLineMessage()
                        Spacer()
                    }
                }
                
                // Consecutive outgoing
                VStack(spacing: 2) {
                    Text("Tues 24. Aug, 20.43")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        OutgoingMultipleLineMessage()
                    }
                    HStack {
                        Spacer()
                        OutgoingDoubleLineMessage()
                    }
                }
               
                // Consecutive incoming
                VStack(spacing: 2) {
                    Text("Tues 31. Aug, 11.07")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        IncomingSingleLineMessage()
                        Spacer()
                    }
                    
                    HStack {
                        IncomingDoubleLineMessage()
                        Spacer()
                    }
                    HStack {
                        IncomingDoubleLineCode()
                        Spacer()
                    }
                }
                
                VStack(spacing: 2) {
                    Text("Mon 23. Aug, 11.00")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        OutgoingMultipleLineMessage()
                    }
                }
                
                // Consecutive incoming
                VStack(spacing: 2) {
                    Text("Sun 22. Aug, 12.07")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        IncomingHugeText()
                        Spacer()
                    }
                    
                    HStack {
                        IncomingEmailAndCode()
                        Spacer()
                    }
                    HStack {
                        IncomingDoubleLineCode()
                        Spacer()
                    }
                }
            } // Scroll area
            .padding(.horizontal)
            
            ComposeAreaView()
                .padding(.bottom, 8)
        }
        //.padding()
    }
}

struct  ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
            .preferredColorScheme(.dark)
    }
}
