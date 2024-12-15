//
//  ContentView.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 11/27/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var isURLProxy: Bool
    
    var body: some View {
        ZStack {
            AppListView()
            if isURLProxy {
                Color(hex: "242424").ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView(isURLProxy: .constant(true))
}
