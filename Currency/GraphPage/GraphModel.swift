//
//  GraphModel.swift
//  Currency
//
//  Created by David on 3/22/24.
//

import Foundation

struct GraphModel: Codable {
    
    let year, month, day: Int
    let baseCode: String
    let requestedAmount: Double
    let conversionAmounts: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case year, month, day
        case baseCode = "base_code"
        case requestedAmount = "requested_amount"
        case conversionAmounts = "conversion_amounts"
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let rate: Double
}
