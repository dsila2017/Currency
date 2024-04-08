//
//  ChartViewModel.swift
//  Currency
//
//  Created by David on 4/5/24.
//

import Foundation
import SwiftUI

@MainActor
class ChartViewModel: ObservableObject {
    
    let id = UUID()
    @Published var chartData: ChartModel?
    @Published var selector: Int = 0
    @Published var dailyData = [String: [String: Double]]()
    @Published var chartDataX = [ChartData]()
    @Published var mainChartData = [ChartData]()
    
    func getData(from: String, to: String) async throws {
        if chartDataX.isEmpty {
            do {
                let data: ChartModel = try await NetworkManager.shared.fetch(from: "https://api.fastforex.io/time-series?from=\(from)&to=\(to)&interval=P1D&api_key=7f51711cb3-121b1b189e-sbfqzk")
                print("FETCHING")
                chartData = data
                dailyData = data.results
                convertData()
                getChartData()
            } catch {
                print(error)
            }
        } else {
            getChartData()
        }
    }
    
    func convertData() {
        var localChartData = [ChartData]()
        for currencyValue in dailyData.values {
            for data in currencyValue {
                localChartData.append(ChartData(date: data.key, datex: convertStringToDate(string: data.key), rate: data.value))
            }
        }
        chartDataX = localChartData.sorted(by: {$0.date < $1.date})
    }
    
    func getChartData() {
        switch selector {
        case 0:
            mainChartData = chartDataX.suffix(3)
        case 1:
            mainChartData = chartDataX.suffix(7)
            print(mainChartData.first?.date)
        case 2:
            mainChartData = chartDataX.suffix(14)
        default:
            mainChartData = chartDataX
        }
    }
    
    func clearData() {
        chartDataX = []
    }
    
    func convertStringToDate(string: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: string) {
                print(date)
                return date
            } else {
                print("Failed to convert the string to a Date.")
                return Date()
            }
        }
    
}
