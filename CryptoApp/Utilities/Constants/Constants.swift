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
        debugPrint("Attempting to read Coingecko Access Token from Info.plist...")
        return token
    }()
}

enum Constants {
    static let githubUser = "mralexgray"
}
