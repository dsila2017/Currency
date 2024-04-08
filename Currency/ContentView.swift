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
            MainPageView()
                .tabItem {
                    Image(systemName: "dollarsign.arrow.circlepath")
                }
            ChartView(model: ChartViewModel())
                .tabItem {
                    Image(systemName: "eurosign.arrow.circlepath")
                }
        }
        .tint(.black)
    }
        
}

#Preview {
    ContentView()
}
