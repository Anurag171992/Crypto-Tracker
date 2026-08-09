//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Anurag on 07/08/26.
//

import SwiftUI

struct CoinImageView: View {
    
    let coin: CoinModel
    @StateObject var coinImageViewModel: CoinImageViewModel
    
    init(coin: CoinModel) {
        self.coin = coin
        _coinImageViewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = coinImageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageViewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .foregroundColor(Color.theme.secondaryTextColor)
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    CoinImageView(coin: PreviewProvider.shared.coin)
        .frame(width: 30.0,height: 30.0)
}
