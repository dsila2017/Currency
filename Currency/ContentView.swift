//
//  ContentView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "dollarsign.arrow.circlepath")
                }
            
            SecondView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                }
        }
        .tint(.black)
    }
        
}

#Preview {
    ContentView()
}
