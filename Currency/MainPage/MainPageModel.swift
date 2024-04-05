//
//  Model.swift
//  Currency
//
//  Created by David on 4/5/24.
//

import Foundation

// MARK: - Welcome
struct CurrencyConversionResult: Codable {
    let base: String
    let amount: Double
    let result: [String: Double]
    let ms: Int
}

struct CurrencyModel: Codable {
    let currencies: [String: String]
    let ms: Int
}
