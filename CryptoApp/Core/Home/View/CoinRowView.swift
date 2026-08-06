//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingColumn: Bool
    
    var body: some View {
        HStack(spacing: 8.0) {
            leftColumn
            Spacer()
            centerColumn
            Spacer()
            rightColumn
        }
        .padding(.horizontal, 10.0)
        .font(.subheadline)
    }
}

#Preview {
    Group {
        CoinRowView(coin: PreviewProvider.shared.coin, showHoldingColumn: true)
            .frame(width: .infinity, height: 50)
        
        CoinRowView(coin: PreviewProvider.shared.coin, showHoldingColumn: true)
            .frame(width: .infinity, height: 50)
            .colorScheme(.dark)
    }
}

extension CoinRowView {
    
    @ViewBuilder
    private var leftColumn: some View {
        Text("\(coin.rank)")
            .font(.headline)
            .foregroundColor(Color.theme.secondaryTextColor)
            .frame(width: 30)
        
        Image(systemName: "heart.fill")
            .resizable()
            .frame(width: 30.0, height: 30.0)
        
        VStack(alignment: .leading) {
            Text(coin.name)
                .font(.headline)
            Text(coin.symbol.uppercased())
                .font(.caption)
        }
        .foregroundColor(Color.theme.accentColor)
    }
    
    @ViewBuilder
    private var centerColumn: some View {
        if showHoldingColumn {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                    .bold()
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundColor(Color.theme.accentColor)
        }
    }
    
    @ViewBuilder
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .font(.headline)
                .foregroundColor(Color.theme.accentColor)
            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                .font(.headline)
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.greenColor : Color.theme.redColor
                )
        }
    }
}
