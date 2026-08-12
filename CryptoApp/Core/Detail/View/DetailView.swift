//
//  DetailView.swift
//  CryptoApp
//
//  Created by Anurag on 12/08/26.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {

    let coin: CoinModel

    @StateObject private var coinDetailViewModel: DetailViewModel

    init(coin: CoinModel) {
        self.coin = coin
        self._coinDetailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
        debugPrint("DetailView Finally loaded with: \(coin.name) coin")
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8.0) {

                    Text(coin.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.redColor)

                    Text(
                        coinDetailViewModel.coinDetails?.description.en
                        ?? "Description not available!"
                    )
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color.theme.secondaryTextColor)
                }
                .padding()
            }
        }
    }
}

#Preview {
    DetailView(coin: PreviewProvider.shared.coin)
}
