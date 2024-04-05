////
////  MainView.swift
////  Currency
////
////  Created by David on 3/18/24.
////
//
//import SwiftUI
//
//struct MainView: View {
//    @ObservedObject var model = viewModel()
//    @FocusState var isFocused: Bool
//    @State var trigger = false
//    
//    @EnvironmentObject var navManager: NavigationManager
//    
//    var body: some View {
//            GeometryReader { geometry in
//                VStack {
//                    HStack {
//                        Text("Convert")
//                            .font(.headline.bold())
//                            .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    .overlay(alignment: .trailing) {
//                        Button {
//                            if model.chartValidation() {
//                                navManager.push(to: .secondView(model: GraphViewModel(baseCurrency: model.selectedFromCurrency, finalCurrency: model.selectedToCurrency)))
//                            } else {
//                                model.showChartAlert = true
//                            }
//                        } label: {
//                            Text("Move")
//                        }
//                        .alert(isPresented: $model.showChartAlert) {
//                            Alert(title: Text("Please select currencies 💱"))
//                        }
//
//                    }
//                    VStack {
//                        CustomRectangle(selectedCurrency: $model.selectedFromCurrency, amount: $model.amount, isFocused: $isFocused, backgroundColor: .yellow, mainText: "Send", array: model.data, disabled: false)
//                            .keyboardType(.decimalPad)
//                            .toolbar {
//                                ToolbarItemGroup(placement: .keyboard) {
//                                    Spacer()
//                                    Button("Done") {
//                                        isFocused = false
//                                    }
//                                    .fontWeight(.bold)
//                                }
//                            }
//                        //                .onChange(of: model.amount + model.selectedFromCurrency + model.selectedToCurrency) {
//                        //                    Task {
//                        //                        do {
//                        //                            try await model.exchange()
//                        //                        } catch {
//                        //                            print(error)
//                        //                        }
//                        //                    }
//                        //                }
//                        CustomRectangle(selectedCurrency: $model.selectedToCurrency, amount: $model.exchangeResult, isFocused: $isFocused, backgroundColor: .purple, mainText: "Receive", array: model.data, disabled: true)
//                    }
//                    .onChange(of: model.amount, {_,_ in
//                        model.filterLetters()
//                        model.clearExchangeAmounts()
//                    })
//                    .overlay {
//                        Button(action: {
//                            trigger.toggle()
//                            model.swapValues()
//                        }, label: {
//                            Image(systemName: "arrow.up.arrow.down.circle.fill")
//                                .foregroundStyle(.customPrimaryDim, .customSecondary)
//                                .font(.system(size: 34))
//                        })
//                        .sensoryFeedback(.selection, trigger: trigger)
//                    }
//                    .padding(.vertical)
//                    
//                    Spacer()
//                    
//                    secondaryRectangle(model: model, text: "Last Updated:", result: model.exchangeDateString)
//                    secondaryRectangle(model: model, text: "Exchange Rate:", result: model.exchangeRate)
//                        .padding(.bottom)
//                    
//                    //ExchangeButton(model: model)
//                }
//                .frame(maxWidth: .infinity,
//                       maxHeight: .infinity,
//                       alignment: .top)
//                .padding()
//                .task {
//                    do {
//                        try await model.getCurrencies()
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            .ignoresSafeArea(.keyboard, edges: .bottom)
//        }
//}
//
//#Preview {
//    MainView()
//}
