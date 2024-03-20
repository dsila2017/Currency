//
//  MainView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = viewModel()
    var body: some View {
        VStack {
            Text("Convert")
                .font(.headline.bold())
            VStack {
                CustomRectangle(backgroundColor: .yellow, mainText: "Send", array: model.data, selectedCurrency: $model.selectedFromCurrency, amount: $model.amount, disabled: false)
                    .keyboardType(.numberPad)
                //                .onChange(of: model.amount + model.selectedFromCurrency + model.selectedToCurrency) {
                //                    Task {
                //                        do {
                //                            try await model.exchange()
                //                        } catch {
                //                            print(error)
                //                        }
                //                    }
                //                }
                CustomRectangle(backgroundColor: .purple, mainText: "Receive", array: model.data, selectedCurrency: $model.selectedToCurrency, amount: $model.exchangeResult, disabled: true)
            }
            .overlay {
                Button(action: {
                    model.swapValues()
                }, label: {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .foregroundStyle(.customPrimaryDim, .customSecondary)
                        .font(.system(size: 34))
                })
            }
            .padding(.vertical)
            
            Spacer()
            
            secondaryRectangle(model: model, text: "Last Updated:", result: model.exchangeDate)
            secondaryRectangle(model: model, text: "Exchange Rate:", result: model.exchangeRate)
            
            Spacer()
            ExchangeButton(model: model)
        }
        .frame(maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading)
        .padding()
        .task {
            do {
                try await model.getCurrencies()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    MainView()
}

struct ExchangeButton: View {
    @StateObject var model: viewModel
    var body: some View {
        Button("Exchange") {
            Task {
                do {
                    try await model.exchange()
                } catch {
                    print(error)
                }
            }
        }
        .alert(isPresented: $model.showDataAlert) {
            switch model.showDataAlertType {
            case .currencyError:
                return Alert(title: Text("Please select currency 💱"))
            case .amountError:
                return Alert(title: Text("Please enter amount 💰"))
            case .currencyWithAmountError:
                return Alert(title: Text("Please select currency 💱 and enter amount 💰"))
            case .none:
                return Alert(title: Text(""))
            }
        }
    }
}

struct secondaryRectangle: View {
    @StateObject var model: viewModel
    var text: String
    var result: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .foregroundStyle(.color)
            HStack {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(result)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundStyle(.customText)
            .font(.subheadline.weight(.medium))
        }
    }
}
