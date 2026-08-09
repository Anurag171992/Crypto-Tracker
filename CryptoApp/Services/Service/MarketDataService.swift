//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: GlobalDataResponse? = nil
    
    var globalMarketSubscription: AnyCancellable?
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        getGlobalData()
    }
    
    private func getGlobalData() {
        globalMarketSubscription = networkManager.requestDataCombine(modelType: GlobalDataModel.self, endPoint: CoinEndpoint.getGlobalData)
        ///sink - Listens to the data that will come in future by the publisher
        ///sink() returns an AnyCancellable representing the active subscription.
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] marketData in
                guard let self else { return }
                self.marketData = marketData.data
                self.globalMarketSubscription?.cancel()
            })
        ///store it in a Set<AnyCancellable> to keep the subscription alive for as long as the owner (typically this class) exists.
        ///When the owner is deallocated, the subscriptions are automatically cancelled, preventing memory leaks and unnecessary work."
        ///This avoids memory leaks
    }
    
}
