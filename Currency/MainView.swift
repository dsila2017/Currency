//
//  MainView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = viewModel()
    @FocusState var isFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Convert")
                    .font(.headline.bold())
                VStack {
                    CustomRectangle(backgroundColor: .yellow, mainText: "Send", array: model.data, selectedCurrency: $model.selectedFromCurrency, amount: $model.amount, disabled: false, isFocused: $isFocused)
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    model.filterLetters()
                                    model.clearExchangeAmounts()
                                    isFocused = false
                                }
                                .fontWeight(.bold)
                            }
                        }
                    //                .onChange(of: model.amount + model.selectedFromCurrency + model.selectedToCurrency) {
                    //                    Task {
                    //                        do {
                    //                            try await model.exchange()
                    //                        } catch {
                    //                            print(error)
                    //                        }
                    //                    }
                    //                }
                    CustomRectangle(backgroundColor: .purple, mainText: "Receive", array: model.data, selectedCurrency: $model.selectedToCurrency, amount: $model.exchangeResult, disabled: true, isFocused: $isFocused)
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
                
                secondaryRectangle(model: model, text: "Last Updated:", result: model.exchangeDateString)
                secondaryRectangle(model: model, text: "Exchange Rate:", result: model.exchangeRate)
                    .padding(.bottom)
                
                ExchangeButton(model: model)
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
            .padding()
            .task {
                do {
                    try await model.getCurrencies()
                } catch {
                    print(error)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainView()
}

struct ExchangeButton: View {
    @StateObject var model: viewModel
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await model.exchange()
                } catch {
                    print(error)
                }
            }
        }, label: {
            HStack {
                Text("Convert")
                Image(systemName: "dollarsign.arrow.circlepath")
            }
            .foregroundStyle(.customPrimaryDim)
            .frame(maxWidth: .infinity, maxHeight: 46)
        })
        .background(.customSecondary)
        .fontWeight(.bold)
        .cornerRadius(24)
        .buttonStyle(.bordered)
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
