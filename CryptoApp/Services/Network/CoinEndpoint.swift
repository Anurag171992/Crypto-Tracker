//
//  CoinEndpoint.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation

//Coinggecko API Info
/*
 
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&include_tokens=top&order=market_cap_desc&per_page=250&sparkline=true&price_change_percentage=24h&page=1
 */


enum CoinEndpoint {
    case getMarketCoins
    case getCommits(owner: String, repositoryName: String)
}

extension CoinEndpoint: EndpointProtocol {
    
    var baseUrl: String {
        return "Https://api.coingecko.com/api/v3/"
    }
    
    var path: String {
        switch self {
        case .getMarketCoins:
            "coins/markets"
            return "/users/\(Constants.githubUser)/repos"

        case let .getCommits(owner, repositoryName):
            return "/repos/\(owner)/\(repositoryName)/commits"
        }
    }
    
    var completeUrl: URL? {
        return URL(string: "\(baseUrl)\(path)")
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var httpHeader: [String: String] {
        [
            "Authorization": "Bearer \(Secrets.coingeckoAccessToken)",
            "Accept": "application/vnd.github+json"
        ]
    }
}
