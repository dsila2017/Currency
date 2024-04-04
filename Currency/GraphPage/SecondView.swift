//
//  SecondView.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import SwiftUI
import Charts

struct SecondView: View {
    @StateObject var model: GraphViewModel
    @State var currentActiveItem: ChartData?
    
    var gradientColor = LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.4), Color.accentColor.opacity(0)]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        VStack {
            Spacer()
            Picker(selection: $model.selector) {
                Text("Day").tag(0)
                Text("Month").tag(1)
                Text("Year").tag(2)
            } label: {
                Text("")
            }
            .frame(maxWidth: 340)
            .pickerStyle(.segmented)
            .onChange(of: model.selector) { oldValue, newValue in
                Task {
                    do {
                        try await model.getData(selector: newValue)
                    } catch {
                        print(error)
                    }
                }
            }
            Spacer()
            Chart {
                ForEach(model.chartData) { day in
                    
                    PointMark(x: .value( "", day.date), y: .value("Rate", day.rate))
                        .foregroundStyle(.black)
                    LineMark(x: .value( "", day.date), y: .value("Rate", day.rate))
                        .foregroundStyle(.red)
                    AreaMark(x: .value("", day.date),
                             y: .value("", day.rate))
                    
                    if let currentActiveItem, currentActiveItem.id == day.id {
                        RuleMark(x: .value("Hour", currentActiveItem.date))
                            .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                            .annotation(position: .automatic) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Rate")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    Text(String(currentActiveItem.rate))
                                        .font(.title3.bold())
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                            }
                    }
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(gradientColor)
            }
            .frame(height: 250)
            .chartXAxis {
                AxisMarks() {
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel(format: .currency(code: "\(model.finalCurrency)"))
                    AxisGridLine()
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    
                                    if let date: Date = proxy.value(atX: location.x) {
                                        let calendar = Calendar.current
                                        var DMY = 0
                                        var HDM = 0
                                        
                                        if let currentItem = model.chartData.first(where: { item in
                                            switch model.selector {
                                            case 0:
                                                DMY = calendar.component(.day, from: date)
                                                HDM = calendar.component(.hour, from: date)
                                                return calendar.component(.day, from: item.date) == DMY && (calendar.component(.hour, from: item.date) == HDM)
                                            case 1:
                                                DMY = calendar.component(.month, from: date)
                                                HDM = calendar.component(.day, from: date)
                                                 return calendar.component(.month, from: item.date) == DMY && calendar.component(.day, from: item.date) == HDM
                                            case 2:
                                                DMY = calendar.component(.year, from: date)
                                                HDM = calendar.component(.month, from: date)
                                                return calendar.component(.year, from: item.date) == DMY && calendar.component(.month, from: item.date) == HDM
                                            default:
                                                HDM = calendar.component(.day, from: date)
                                                 return calendar.component(.day, from: item.date) == DMY && calendar.component(.hour, from: item.date) == HDM
                                            }
                                        }) {
                                            self.currentActiveItem = currentItem
                                        }
                                    }
                                }.onEnded({ value in
                                    self.currentActiveItem = nil
                                }))
                }
            }
            .padding()
            Spacer()
        }
        .task {
            do {
                try await model.getData(selector: model.selector)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SecondView(model: GraphViewModel(baseCurrency: "USD", finalCurrency: "GEL"))
}
