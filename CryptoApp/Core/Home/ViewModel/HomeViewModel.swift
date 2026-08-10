//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var marketData : [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    private let dataService = CoinDataService(networkManager: NetworkManager())
    private let marketDataService = MarketDataService(networkManager: NetworkManager())
    private let portfolioDataService = PortfolioDataService()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
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
        
        //Updates Market Data 
        marketDataService.$marketData
            .map(self.transformToStatistics)
            .sink { [weak self] marketData in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.marketData = marketData
                }
            }.store(in: &cancellables)
        
        //CoreData - portfolioCoins
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map({ (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels.compactMap { (coin) -> CoinModel? in
                    guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.upddateCurrentHoldings(amount: entity.amount)
                }
            })
            .sink { [weak self] returnedCoins in
                guard let self else { return }
                self.portfolioCoins = returnedCoins
            }.store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func transformToStatistics(from globalDataResponse: GlobalDataResponse?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = globalDataResponse else {return stats}
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume, percentageChange: data.volumeChangePercentage24HUsd)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance, percentageChange: nil)
        let portfolio = StatisticModel(title: "Portfolio", value: "$0.0", percentageChange: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
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
