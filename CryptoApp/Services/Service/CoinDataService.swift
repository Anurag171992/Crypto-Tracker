//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        getCoins()
    }
    
    func getCoins() {
        coinSubscription = networkManager.requestDataCombine(modelType: [CoinModel].self, endPoint: CoinEndpoint.getMarketCoins(currency: "usd", page: 1))
        ///sink - Listens to the data that will come in future by the publisher
        ///sink() returns an AnyCancellable representing the active subscription.
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                guard let self else { return }
                self.allCoins = returnedCoins
                self.coinSubscription?.cancel()
            })
        ///store it in a Set<AnyCancellable> to keep the subscription alive for as long as the owner (typically this class) exists.
        ///When the owner is deallocated, the subscriptions are automatically cancelled, preventing memory leaks and unnecessary work."
        ///This avoids memory leaks
    }
}
