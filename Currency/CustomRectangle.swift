//
//  CustomRectangle.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

struct CustomRectangle: View {
    @State var text = ""
    var backgroundColor: Color
    var mainText: String
    var array: [[String]]
    //var currencyNames: [String]
    @Binding var selectedCurrency: String
    @Binding var amount: String
    var disabled: Bool
    
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
                .frame(maxHeight: 170)
                .foregroundStyle(backgroundColor.opacity(0.3))
            VStack {
                Text(mainText)
                    .foregroundStyle(.customSecondary)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                HStack {
                    TextField(text: $amount) {
                        Text("Amount")
                            .foregroundStyle(.customSecondaryDim)
                    }
                    .foregroundStyle(.customSecondary)
                    .padding()
                    .frame(height: 70)
                    .font(.largeTitle.bold())
                    .disabled(disabled)
                    .focused($isFocused)
                    
                    Menu {
                        ForEach(self.array, id: \.self) { element in
                            Button(element[1] + ":" + " " + element[0] , action: {
                                self.selectedCurrency = element[0]
                            })
                        }
                    } label: {
                        Text(selectedCurrency)
                        Image(systemName: "chevron.down")
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.customSecondary)
                    .onTapGesture {
                        isFocused = false
                    }


                }
            }
            .padding()
        }
    }
}

//#Preview {
//    CustomRectangle(backgroundColor: .red, mainText: "Send", array: ["USD", "GEL", "3", "4"])
//}
