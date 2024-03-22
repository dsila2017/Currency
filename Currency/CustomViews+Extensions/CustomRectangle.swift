//
//  CustomRectangle.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI

struct CustomRectangle: View {
    @Binding var selectedCurrency: String
    @Binding var amount: String
    @State var selectTrigger = false
    @FocusState.Binding var isFocused: Bool
    
    var backgroundColor: Color
    var mainText: String
    var array: [[String]]
    var disabled: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .circular)
                .frame(maxHeight: 170)
                .foregroundStyle(backgroundColor.opacity(0.3))
                .onTapGesture {
                    isFocused = false
                }
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
                    .sensoryFeedback(.selection, trigger: isFocused) {_,_  in
                        isFocused == true
                    }
                    
                    Menu {
                        ForEach(self.array, id: \.self) { element in
                            Button(element[1] + ":" + " " + element[0] , action: {
                                self.selectedCurrency = element[0]
                                self.selectTrigger.toggle()
                            })
                        }
                    } label: {
                        Text(selectedCurrency)
                        Image(systemName: "chevron.down")
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.customSecondary)
                    .onTapGesture(perform: {
                        isFocused = false
                        self.selectTrigger.toggle()
                    })
                    .sensoryFeedback(.selection, trigger: selectTrigger)
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    CustomRectangle(backgroundColor: .red, mainText: "Send", array: ["USD", "GEL", "3", "4"])
//}
