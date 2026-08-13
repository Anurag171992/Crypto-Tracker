//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Anurag on 12/08/26.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {

    let dataService: CoinDetailDataService
    @Published var overViewStatistics: [StatisticModel] = []
    @Published var additionalViewStatistics: [StatisticModel] = []
    
    @Published var coinDetails: CoinDetailModel?

    private var cancellables = Set<AnyCancellable>()
    
    @Published var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinDetailDataService(
            networkManager: NetworkManager(),
            coin: coin
        )

        addSubscribers()
    }

    private func addSubscribers() {
        dataService.$coinDetails
            .combineLatest($coin)
            .map(self.overViewAndAdditionalInfo)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedArrays in
                guard let self else {return}
                self.overViewStatistics = returnedArrays.0
                self.additionalViewStatistics = returnedArrays.1
            }
            .store(in: &cancellables)
    }
    
    private func overViewAndAdditionalInfo(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overView: [StatisticModel], additional: [StatisticModel]) {
        self.coinDetails = coinDetailModel
        return (createOverViewStats(coinModel: coinModel), createAdditionalStats(coinDetailModel: coinDetailModel, coinModel: coinModel))
    }
    
    private func createOverViewStats(coinModel: CoinModel) -> [StatisticModel] {
        //OverView
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStats = StatisticModel(title: "Current Price", value: price, percentageChange: priceChange)
        
        let marketCap = "$" + (coinModel.marketCap.formattedWithAbbreviations())
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStats = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStats = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + "\(coinModel.totalVolume.formattedWithAbbreviations())"
        let volumeStats = StatisticModel(title: "Volume", value: volume)
        
        let overViewArray : [StatisticModel] = [
            priceStats, marketCapStats, rankStats, volumeStats
        ]
        
        return overViewArray
    }
    
    private func createAdditionalStats(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        //Additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStats = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStats = StatisticModel(title: "24h Low", value: low)
        
        let priceChange24 = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let priceChange24Percentage = coinModel.priceChangePercentage24H
        let priceChangeStats = StatisticModel(title: "24h Price Change", value: priceChange24, percentageChange: priceChange24Percentage)
        
        let marketCapChange2 = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage = coinModel.marketCapChangePercentage24H
        let marketCapStats2 = StatisticModel(title: "24h MarketCap Change ", value: marketCapChange2, percentageChange: marketCapChangePercentage)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime) min"
        let blockTimeStats = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStats = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [StatisticModel] = [
            highStats, lowStats, priceChangeStats, marketCapStats2, blockTimeStats, hashingStats
        ]
        
        return additionalArray
    }
}
