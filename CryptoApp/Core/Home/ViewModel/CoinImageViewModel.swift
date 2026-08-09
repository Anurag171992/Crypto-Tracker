//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Anurag on 07/08/26.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
   
    private let coin: CoinModel
    private let coinImageService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinImageService = CoinImageService(coin: coin, networkManager: NetworkManager())
        addSubscribers()
        self.isLoading = true
    }
    
    func addSubscribers() {
        coinImageService.$image.sink(receiveValue: { [weak self] image in
            guard let self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.image = image
            }
        }).store(in: &cancellables)
    }
}
