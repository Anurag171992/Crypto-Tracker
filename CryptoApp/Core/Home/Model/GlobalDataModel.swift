//
//  GlobalDataModel.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import Foundation

struct GlobalDataModel: Codable, Hashable {
    let data: GlobalDataResponse
}

struct GlobalDataResponse: Codable, Hashable {
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]

    let marketCapChangePercentage24HUsd: Double
    let volumeChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"

        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case volumeChangePercentage24HUsd = "volume_change_percentage_24h_usd"
    }
    
    var marketCap : String {
        if let item = totalMarketCap.first(where: { (key, value) in
            return key == "usd"
        }) {
            return "$\(item.value.formattedWithAbbreviations())"
        }
        return ""
    }
    
    var volume : String {
        if let item = totalVolume.first(where: { (key, value) in
            return key == "usd"
        }) {
            return "$\(item.value.formattedWithAbbreviations())"
        }
        return ""
    }
    
    var btcDominance : String {
        if let item = marketCapPercentage.first(where: { (key, value) in
            return key == "btc"
        }) {
            return "\(item.value.formattedWithAbbreviations())"
        }
        return ""
    }
}
