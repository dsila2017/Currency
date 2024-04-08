//
//  File.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import Foundation

enum MainAlertType {
    case currencyError, amountError, currencyWithAmountError
}

@MainActor
class mainPageViewModel: ObservableObject {
    @Published var data: [[String]] = [[String]]()
    @Published var rawData: [String: String] = [String: String]()
    @Published var selectedFromCurrency = "Select"
    @Published var selectedToCurrency = "Select"
    @Published var amount = ""
    @Published var exchangeRate = "0.00"
    @Published var exchangeResult = ""
    @Published var responseMS = "-"
    @Published var exchangeDate: Date = Date()
    @Published var showDataAlert = false
    @Published var showChartAlert = false
    @Published var showDataAlertType: MainAlertType?

    init() {
        print("INITIALIZING")
        Task {
                do {
                    try await getCurrencies()
                } catch {
                    print(error)
                }
            }
    }
    
    func sortDataArray() {
        var tempData = [[String]]()
        for i in rawData {
            tempData.append([i.key, i.value])
        }
        data = tempData.sorted(by: {$0[1] < $1[1]})
    }
    
    func getCurrencies() async throws {
        do {
            let result: CurrencyModel = try await NetworkManager.shared.fetch(from: "https://api.fastforex.io/currencies?api_key=7f51711cb3-121b1b189e-sbfqzk")
            self.rawData = result.currencies
            sortDataArray()
        } catch {
            print(error)
        }
    }
    
    func exchange() async throws {
        if dataValidation() {
            do {
                let result: CurrencyConversionResult = try await NetworkManager.shared.fetch(from: "https://api.fastforex.io/convert?from=\(selectedFromCurrency)&to=\(selectedToCurrency)&amount=\(amount)&api_key=7f51711cb3-121b1b189e-sbfqzk")
                exchangeRate = String(result.result["rate"] ?? 0)
                exchangeResult = String(result.result[selectedToCurrency] ?? 0)
                responseMS = String(result.ms) + " " + "ms"
                print(result)
            } catch {
                print(error)
            }
        } else {
            showDataAlert = true
        }
    }
    
    func swapValues() {
        if selectedFromCurrency != "Select" || selectedToCurrency != "Select" {
            (selectedFromCurrency, selectedToCurrency) = (selectedToCurrency, selectedFromCurrency)
            clearExchangeAmounts()
        }
    }
    
    func chartValidation() -> Bool {
        if selectedFromCurrency != "Select" && selectedToCurrency != "Select" {
            return true
        }
        return false
    }
    
    func dataValidation() -> Bool {
        filterLetters()
        if selectedFromCurrency != "Select" && selectedToCurrency != "Select" {
            if amount == "" {
                clearExchangeAmounts()
                showDataAlertType = MainAlertType.amountError
                return false
            }
        }
        else if selectedFromCurrency == "Select" || selectedToCurrency == "Select" {
            if amount == "" {
                showDataAlertType = MainAlertType.currencyWithAmountError
                return false
            }
            else {
                showDataAlertType = MainAlertType.currencyError
                return false
            }
        }
        return true
    }
    
    func clearExchangeAmounts() {
        if exchangeResult != "" {
            exchangeResult = ""
            clearResponseAndRate()
        }
    }
    
    func clearResponseAndRate() {
        print("ENTERED")
        if responseMS != "-" && exchangeRate != "0.00" {
            responseMS = "-"
            exchangeRate = "0.00"
        }
    }
    
    func filterLetters() {
        amount = amount.filter({$0.isNumber || $0 == "."})
    }
    
    func convertStringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            print("Failed to convert the string to a Date.")
            return Date()
        }
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        let localizedDate = dateFormatter.string(from: date)
        return localizedDate
    }
}
