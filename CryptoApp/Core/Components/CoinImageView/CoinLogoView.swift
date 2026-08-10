//
//  CoinLogoView.swift
//  CryptoApp
//
//  Created by Anurag on 10/08/26.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .foregroundColor(Color.theme.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(coin.name)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CoinLogoView(coin: PreviewProvider.shared.coin)
}
