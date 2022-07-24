//
//  GroupBoxStyle.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/23/22.
//

import Foundation
import SwiftUI



struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(Color.MyTheme.lightBlueColor)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
