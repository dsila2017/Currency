//
//  ContentView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
            MainView()
                .tabItem {
                    Image(systemName: "dollarsign.arrow.circlepath")
                }
        .tint(.black)
    }
        
}

#Preview {
    ContentView()
}
