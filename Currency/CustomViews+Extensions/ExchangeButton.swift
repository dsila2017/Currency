//
//  ExchangeButton.swift
//  Currency
//
//  Created by David on 3/21/24.
//

import Foundation
import SwiftUI

struct ExchangeButton: View {
    @StateObject var model: viewModel
    @State var trigger = false
    var body: some View {
        Button(action: {
            trigger.toggle()
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
        .sensoryFeedback(.selection, trigger: trigger)
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
