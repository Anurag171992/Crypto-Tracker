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
    
    init(coin: CoinModel) {
        self.coin = coin
        debugPrint("DetailView Finally loaded with: \(coin.name) coin")
    }
    
    var body: some View {
        ZStack {
            Text(coin.name)
        }
    }
}

#Preview {
    DetailView(coin: PreviewProvider.shared.coin)
}
