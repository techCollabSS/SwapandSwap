//
//  LazyView.swift
//  SwApp
//
//  Created by Juan Alvarez on 12/4/21.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
    
}
