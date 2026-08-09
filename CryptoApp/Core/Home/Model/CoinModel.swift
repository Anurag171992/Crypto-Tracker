//
//  CoinModel.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation

struct CoinModel: Codable, Identifiable, Sendable {
    let id: String
    let symbol: String
    let name: String
    let image: String

    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int?
    let fullyDilutedValuation: Double?

    let totalVolume: Double

    let high24H: Double?
    let low24H: Double?

    let priceChange24H: Double?
    let priceChangePercentage24H: Double?

    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?

    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?

    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?

    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?

    let roi: ROI?
    let lastUpdated: String?

    let sparklineIn7D: SparklineIn7D?
    let currentHoldings : Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image

        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"

        case totalVolume = "total_volume"

        case high24H = "high_24h"
        case low24H = "low_24h"

        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"

        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"

        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"

        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"

        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"

        case roi
        case lastUpdated = "last_updated"

        case sparklineIn7D = "sparkline_in_7d"
        case currentHoldings
    }
    
    ///Immutable update pattern, As property is let inside coinModel struct , so we create a new object
    ///Purpose: Same coin but only to update holdings new CoinModel object returned.
    ///We will be using it to update the PORTFOLIO
    func upddateCurrentHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, roi: roi, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, currentHoldings: amount)
    }
    
    ///Computed properties: They compute something and return
    var currentHoldingsValue: Double {
        get {
            return (currentHoldings ?? 0) * currentPrice
        }
    }
    
    var rank: Int {
        get {
            return marketCapRank ?? 0
        }
    }
}

struct SparklineIn7D: Codable, Sendable {
    let price: [Double]
}

struct ROI: Codable, Sendable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}
