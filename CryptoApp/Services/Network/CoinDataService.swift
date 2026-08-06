//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false") else {
            return
        }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)///Creates a Publisher
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw DataError.invalidResponse
                }
                return output.data
            }
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        ///sink - Listens to the data that will come in future by the publisher
        ///sink() returns an AnyCancellable representing the active subscription.
            .sink { completion in
                switch completion {
                case .finished:
                    break
                    
                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { [weak self] returnedCoins in
                guard let self else { return }
                self.allCoins = returnedCoins
                self.coinSubscription?.cancel()
            }
        ///store it in a Set<AnyCancellable> to keep the subscription alive for as long as the owner (typically this class) exists.
        ///When the owner is deallocated, the subscriptions are automatically cancelled, preventing memory leaks and unnecessary work."
        ///This avoids memory leaks
    }
}
