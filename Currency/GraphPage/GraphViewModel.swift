//
//  GraphViewModel.swift
//  Currency
//
//  Created by David on 3/22/24.
//

import Foundation

@MainActor
class GraphViewModel: ObservableObject {
    @Published var rawChartData = [CustomDate: [GraphModel]]()
    @Published var chartData = [ChartData]()
    @Published var selector: Int = 0
    var baseCurrency: String
    var finalCurrency: String
    
    init(baseCurrency: String, finalCurrency: String) {
        self.baseCurrency = baseCurrency
        self.finalCurrency = finalCurrency
    }
    
    func getHistoryDate(date: CustomDate, agoValue: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let currentDate = Date()
        
        switch date {
        case .Day:
            print(calendar.date(byAdding: .day, value: -agoValue, to: currentDate)!)
            return calendar.date(byAdding: .day, value: -agoValue, to: currentDate)!
        case .Month:
            return calendar.date(byAdding: .month, value: -agoValue, to: currentDate)!
        case .Year:
            return calendar.date(byAdding: .year, value: -agoValue, to: currentDate)!
        }
    }
    
    func getHistoryResult(type: CustomDate) async throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let firstDate = calendar.dateComponents([.year, .month, .day], from: getHistoryDate(date: type, agoValue: 0))
        let secondDate = calendar.dateComponents([.year, .month, .day], from: getHistoryDate(date: type, agoValue: 1))
        let thirdDate = calendar.dateComponents([.year, .month, .day], from: getHistoryDate(date: type, agoValue: 2))
        let fourthDate = calendar.dateComponents([.year, .month, .day], from: getHistoryDate(date: type, agoValue: 3))
        let fifthDate = calendar.dateComponents([.year, .month, .day], from: getHistoryDate(date: type, agoValue: 4))
        
        let dateStampArray = [firstDate, secondDate, thirdDate, fourthDate, fifthDate]
        var dataArray = [GraphModel]()
        
        for date in dateStampArray {
            guard let year = date.year, let month = date.month, let day = date.day else { return }
            do {
                let data: GraphModel = try await NetworkManager.shared.fetch(from: "https://v6.exchangerate-api.com/v6/5a9b9687e1b86c4c225b9e28/history/\(baseCurrency)/\(year)/\(month)/\(day)/1")
                dataArray.append(data)
            } catch {
                print(error)
            }
        }
        switch type {
        case .Day:
            rawChartData[.Day] = dataArray
            chartData = convertToChartsDatax(rawData: rawChartData, finalCurrency: finalCurrency, type: .Day)
        case .Month:
            rawChartData[.Month] = dataArray
            chartData = convertToChartsDatax(rawData: rawChartData, finalCurrency: finalCurrency, type: .Month)
        case .Year:
            rawChartData[.Year] = dataArray
            chartData = convertToChartsDatax(rawData: rawChartData, finalCurrency: finalCurrency, type: .Year)
        }
    }
    
    func convertToChartsDatax(rawData: [CustomDate: [GraphModel]], finalCurrency: String, type: CustomDate) -> [ChartData] {
        var chartData = [ChartData]()
        guard let data = rawData[type] else {return []}
        
        for i in data {
            
            let calendar = Calendar(identifier: .gregorian)
            let components = DateComponents(year: i.year, month: i.month, day: i.day)
            let date = calendar.date(from: components)!
            
            chartData.append(ChartData(date: date, rate: i.conversionAmounts[finalCurrency]!))
        }
        return chartData
    }
    
    func getData(selector: Int) async throws {
        switch selector {
        case 0:
            try await getHistoryResult(type: .Day)
        case 1:
            try await getHistoryResult(type: .Month)
        case 2:
            try await getHistoryResult(type: .Year)
        default:
            return
        }
    }
}

enum CustomDate {
    case Day, Month, Year
}
