//
//  CurrencyApp.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

@main
struct CurrencyApp: App {
    @StateObject var navManager = NavigationManager()
    @StateObject var mainModel = mainPageViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navManager.path) {
                ContentView()
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case.chartView(let model):
                            ChartView(model: model)
                        }
                    }
            }
            .environmentObject(navManager)
            .environmentObject(mainModel)
        }
    }
}
