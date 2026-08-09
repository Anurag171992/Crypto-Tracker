//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Anurag on 07/08/26.
//

import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private let coin: CoinModel
    private var coinImageSubscription: AnyCancellable?
   
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage(urlString: coin.image)
    }
 
    private func getCoinImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        coinImageSubscription = NetworkManager.shared.downloadData(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self else { return }
                self.image = returnedImage
                self.coinImageSubscription?.cancel()
            })
        ///store it in a Set<AnyCancellable> to keep the subscription alive for as long as the owner (typically this class) exists.
        ///When the owner is deallocated, the subscriptions are automatically cancelled, preventing memory leaks and unnecessary work."
        ///This avoids memory leaks
    }
    
}
