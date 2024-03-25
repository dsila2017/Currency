//
//  CurrencyModel.swift
//  Currency
//
//  Created by David on 3/18/24.
//

import Foundation

struct CurrencyModel: Codable {
    let result: String
    let documentation, termsOfUse: String
    let supportedCodes: [[String]]

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case supportedCodes = "supported_codes"
    }
}

struct ExchangeRateModel: Codable {
    let result: String
    let documentation, termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode, targetCode: String
    let conversionRate, conversionResult: Double

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
        case conversionResult = "conversion_result"
    }
}
