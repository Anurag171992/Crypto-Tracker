//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Anurag on 12/08/26.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    var coinSubscription: AnyCancellable?
    var networkManager: NetworkManager
    var coin: CoinModel
    
    init(networkManager: NetworkManager, coin: CoinModel) {
        self.networkManager = networkManager
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail() {
        coinSubscription = networkManager.requestDataCombine(modelType: CoinDetailModel.self, endPoint: CoinEndpoint.getDetailCoinData(coinName: coin.id))
        ///sink - Listens to the data that will come in future by the publisher
        ///sink() returns an AnyCancellable representing the active subscription.
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                guard let self else { return }
                self.coinDetails = returnedCoins
                self.coinSubscription?.cancel()
            })
        ///store it in a Set<AnyCancellable> to keep the subscription alive for as long as the owner (typically this class) exists.
        ///When the owner is deallocated, the subscriptions are automatically cancelled, preventing memory leaks and unnecessary work."
        ///This avoids memory leaks
    }
}
