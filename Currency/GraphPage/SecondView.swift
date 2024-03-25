//
//  SecondView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI
import Charts

struct SecondView: View {
    @StateObject var model = GraphViewModel(baseCurrency: "USD", finalCurrency: "EUR")
    
    var gradientColor = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0)]), startPoint: .top, endPoint: .bottom)
    var body: some View {
        VStack {
            
            Chart {
                ForEach(model.chartData) { day in
                    LineMark(x: .value( "Month", day.date), y: .value("Rate", day.rate))
                }
                .interpolationMethod(.cardinal)
                
                ForEach(model.chartData) { day in
                    AreaMark(x: .value("Year", day.date),
                             y: .value("Population", day.rate))
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(gradientColor)
                
            }
//            .chartXAxis {
//                AxisMarks(preset: .extended, position: .bottom, values: .stride(by: .day)) { value in
//                    
//                }
//            }
            
            Picker(selection: $model.selector) {
                Text("Day").tag(0)
                Text("Month").tag(1)
                Text("Year").tag(2)
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)
            .onChange(of: model.selector) { oldValue, newValue in
                Task {
                    do {
                        try await model.getData(selector: newValue)
                    }catch {
                        print(error)
                    }
                }
            }
        }
        .task {
            do {
                try await model.getData(selector: model.selector)
            }catch {
                print(error)
            }
        }
    }
        
}

#Preview {
    SecondView()
}
