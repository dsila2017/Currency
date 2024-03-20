//
//  File.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import Foundation

enum AlertType {
    case currencyError, amountError, currencyWithAmountError
}
@MainActor
class viewModel: ObservableObject {
    @Published var data: [[String]] = [[""]]
    @Published var selectedFromCurrency = "Select"
    @Published var selectedToCurrency = "Select"
    @Published var amount = ""
    @Published var exchangeRate = "0.00"
    @Published var exchangeResult = ""
    @Published var exchangeDate = "Now"
    @Published var showDataAlert = false
    @Published var showDataAlertType: AlertType?
    
    func getCurrencies() async throws {
        do {
            let result: CurrencyModel = try await NetworkManager.shared.fetch(from: "https://v6.exchangerate-api.com/v6/5a9b9687e1b86c4c225b9e28/codes")
            self.data = result.supportedCodes
        } catch {
            print(error)
        }
    }
    
    func exchange() async throws {
        if dataValidation() {
            do {
                let result: ExchangeRateModel = try await NetworkManager.shared.fetch(from: "https://v6.exchangerate-api.com/v6/5a9b9687e1b86c4c225b9e28/pair/\(selectedFromCurrency)/\(selectedToCurrency)/\(amount)")
                exchangeRate = String(round(result.conversionRate * 1000) / 1000)
                exchangeResult = String(round(result.conversionResult * 1000) / 1000)
                exchangeDate = result.timeLastUpdateUTC
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
        }
    }
    
    func dataValidation() -> Bool {
        if selectedFromCurrency != "Select" && selectedToCurrency != "Select" {
            if amount == "" {
                clearExchangeAmounts()
                showDataAlertType = AlertType.amountError
                return false
            }
        }
        else if selectedFromCurrency == "Select" || selectedToCurrency == "Select" {
            if amount == "" {
                showDataAlertType = AlertType.currencyWithAmountError
                return false
            }
            else {
                showDataAlertType = AlertType.currencyError
                return false
            }
        }
        return true
    }
    
    func clearExchangeAmounts() {
        if exchangeResult != "" {
            exchangeResult = ""
        }
    }
}