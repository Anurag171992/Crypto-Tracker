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
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    private let dataService = CoinDataService(networkManager: NetworkManager())
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        //        dataService.$allCoins.sink(receiveValue: { [weak self] coins in
        //            guard let self else { return }
        //            DispatchQueue.main.async {
        //                self.allCoins = coins
        //                    .filter { ($0.marketCapRank ?? 0) > 0 }
        //                    .sorted {
        //                        ($0.marketCapRank ?? Int.max) < ($1.marketCapRank ?? Int.max)
        //                    }
        //            }
        //        }).store(in: &cancellables)
        
        ///Here using combineLatest we are subscrinbing to both searchText and allCoins , so anything changes in these the code will run
        ///Hence the wbove code is no longer needed
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(self.filterCoins)
        ///This is giving the data after the logic is applied
            .sink { [weak self] (returnedCoins) in
                guard let self else {return}
                DispatchQueue.main.async {
                    self.allCoins = returnedCoins
                        .filter { ($0.marketCapRank ?? 0) > 0 }
                        .sorted {
                            ($0.marketCapRank ?? Int.max) < ($1.marketCapRank ?? Int.max)
                        }
                }
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return startingCoins }
        
        let lowercasedText = text.lowercased()
        return startingCoins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
}
