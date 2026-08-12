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
    @Published var isLoading: Bool = false
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
        
        //update portfolioCoins
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
        
        //Updates Market Data 
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(self.transformToStatistics)
            .sink { [weak self] marketData in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.marketData = marketData
                    self.isLoading = false
                    debugPrint("isLoading is now: \(self.isLoading)")
                }
            }.store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        debugPrint("isLoading is now: \(self.isLoading)")
        dataService.getCoins()
        marketDataService.getGlobalData()
        HapticManager.generate()
    }
    
    private func transformToStatistics(from globalDataResponse: GlobalDataResponse?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = globalDataResponse else {return stats}
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume, percentageChange: data.volumeChangePercentage24HUsd)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance, percentageChange: nil)
        
        let portfolioValue = portfolioCoins.map { (coin) -> Double in
            return coin.currentHoldingsValue
        }
        let totalValue = portfolioValue.reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentageChange)
            return previousValue
        }
        
        let totalPercentageChangeValue = previousValue.reduce(0, +)
        let percentageChange = ((totalValue - totalPercentageChangeValue) / totalPercentageChangeValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: totalValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
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
