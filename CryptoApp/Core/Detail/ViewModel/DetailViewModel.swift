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
    @Published var coinDetails: CoinDetailModel?
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.dataService = CoinDetailDataService(networkManager: NetworkManager(), coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        dataService.$coinDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coinDetails in
                self?.coinDetails = coinDetails
            }
            .store(in: &cancellables)
    }
}
