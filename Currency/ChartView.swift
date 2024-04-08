//
//  SecondView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var model: ChartViewModel
    @EnvironmentObject var mainModel: mainPageViewModel
    @State var currentActiveItem: ChartData?
    var chartData = [ChartData]()
    @State var selectedValue: Date?
    @State var selectedValuex: Date?
    
    var gradientColor = LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.4), Color.accentColor.opacity(0)]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        VStack {
            Spacer()
            Picker(selection: $model.selector) {
                Text("3 Days").tag(0)
                Text("1 Week").tag(1)
                Text("2 Week").tag(2)
            } label: {
                Text("")
            }
            .frame(maxWidth: 340)
            .pickerStyle(.segmented)
            .onChange(of: model.selector) { oldValue, newValue in
                Task {
                    do {
                        try await model.getData(from: mainModel.selectedFromCurrency, to: mainModel.selectedToCurrency)
                    } catch {
                        print(error)
                    }
                }
            }
            Spacer()
            Chart {
                ForEach(model.mainChartData) { data in
                    PointMark(x: .value( "", data.datex, unit: .day), y: .value("Rate", data.rate))
                        .foregroundStyle(.black)
                    BarMark(x: .value( "", data.datex, unit: .day), y: .value("Rate", data.rate))
                        .foregroundStyle(.red)
                    
                    if let selectedValue {
                        RuleMark(x: .value("Month", selectedValue))
                            .annotation(position: .topLeading, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
                                if let datx = model.mainChartData.first(where: {$0.datex.formatted(date: .numeric, time: .omitted) == selectedValue.formatted(date: .numeric, time: .omitted)}) {
                                    Text("\(datx.rate)")
                                }
                                
                            }
                    }
                }
                .foregroundStyle(gradientColor)
            }
            .chartXSelection(value: $selectedValue)
            .frame(height: 250)
            .chartXAxis {
                AxisMarks() {
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel(format: .currency(code: "\(mainModel.selectedToCurrency)"))
                    AxisGridLine()
                }
            }
            .padding()
            Spacer()
            Text("\(selectedValue?.description ?? "")")
        }
        .task {
            model.clearData()
            do {
                try await model.getData(from: mainModel.selectedFromCurrency, to: mainModel.selectedToCurrency)
            } catch {
                print(error)
            }
        }
    }
}

//#Preview {
//    ChartView(model: ChartViewModel())
//}
