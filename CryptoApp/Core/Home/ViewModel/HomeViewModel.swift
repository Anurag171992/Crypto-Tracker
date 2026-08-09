//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let dataService = CoinDataService()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allCoins.sink(receiveValue: { [weak self] coins in
            guard let self else { return }
            DispatchQueue.main.async {
                self.allCoins = coins
                    .filter { ($0.marketCapRank ?? 0) > 0 }
                    .sorted {
                        ($0.marketCapRank ?? Int.max) < ($1.marketCapRank ?? Int.max)
                    }
            }
        }).store(in: &cancellables)
    }
}
