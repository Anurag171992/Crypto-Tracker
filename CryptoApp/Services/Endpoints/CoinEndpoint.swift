//
//  CoinEndpoint.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//
import Foundation

enum CoinEndpoint {
    case getMarketCoins(currency: String, page: Int)
}

extension CoinEndpoint: EndpointProtocol {

    var baseUrl: String {
        "https://api.coingecko.com/api/v3/"
    }

    var path: String {
        switch self {
        case .getMarketCoins:
            return "coins/markets"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case let .getMarketCoins(currency, page):
            return [
                URLQueryItem(name: "vs_currency", value: currency),
                URLQueryItem(name: "include_tokens", value: "top"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "250"),
                URLQueryItem(name: "sparkline", value: "true"),
                URLQueryItem(name: "price_change_percentage", value: "24h"),
                URLQueryItem(name: "page", value: String(page))
            ]
        }
    }

    var completeUrl: URL? {
        var components = URLComponents(
            string: "\(baseUrl)\(path)"
        )

        components?.queryItems = queryItems

        return components?.url
    }

    var method: HTTPMethod {
        .get
    }

    var httpHeader: [String: String] {
        [
            "Accept": "application/json",
            "x-cg-demo-api-key": Secrets.coingeckoAccessToken
        ]
    }
}
