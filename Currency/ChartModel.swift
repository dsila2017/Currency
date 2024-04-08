//
//  ChartModel.swift
//  Currency
//
//  Created by David on 4/5/24.
//

import Foundation

struct ChartModel: Codable {
    let start, end, interval, base: String
    let results: [String: [String: Double]]
    let ms: Int
}

struct ChartData: Identifiable {
    let id = UUID()
    let date: String
    let datex: Date
    let rate: Double
}
