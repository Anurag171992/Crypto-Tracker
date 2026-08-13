//
//  Constants.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation

enum Secrets {
    static let coingeckoAccessToken: String = {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "AccessToken") as? String else {
            fatalError("Missing Coingecko AccessToken")
        }
        return token
    }()
}

enum Constants {
    static let linedInProfile = URL(string: "https://www.linkedin.com/in/anurag-kashyap-2a1b22a0/")
    static let coingecko = URL(string: "https://docs.coingecko.com")
}
