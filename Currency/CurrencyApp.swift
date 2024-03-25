//
//  CurrencyApp.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

@main
struct CurrencyApp: App {
    @ObservedObject var navManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navManager.path) {
                ContentView()
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case.secondView(let model):
                            SecondView(model: model)
                        }
                    }
            }
            .environmentObject(navManager)
        }
    }
}
