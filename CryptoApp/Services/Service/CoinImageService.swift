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
    
    var networkManager: NetworkManager
    private let fileManager = LocalFileManager.shared
    private let folderName = "coin_images"
    private let imageName: String
    

    init(coin: CoinModel, networkManager: NetworkManager) {
        self.coin = coin
        self.networkManager = networkManager
        self.imageName = coin.id
        getCoinImage()
    }
 
    private func getCoinImage() {
        if let returnedImage = fileManager.getImage(imageName: self.imageName, folderName: folderName) {
            self.image = returnedImage
            debugPrint("Successfully recieved image from file Manger")
        } else {
            debugPrint("Downloading Image from Server!")
            downloadCoinImage(urlString: coin.image)
        }
    }
    
    private func downloadCoinImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        coinImageSubscription = networkManager.downloadData(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downLoadedImage = returnedImage else { return }
                self.image = downLoadedImage
                self.coinImageSubscription?.cancel()
                //Saving images to the fileManager
                self.fileManager.saveImage(image: downLoadedImage, ImageName: self.imageName, folderName: folderName)
            })
        ///store it in a Set<AnyCancellable> to keep the subscription alive for as long as the owner (typically this class) exists.
        ///When the owner is deallocated, the subscriptions are automatically cancelled, preventing memory leaks and unnecessary work."
        ///This avoids memory leaks
    }
    
}
