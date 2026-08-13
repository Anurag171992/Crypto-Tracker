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
    
    @StateObject private var coinDetailViewModel: DetailViewModel
    @State private var showMoreDesciption: Bool = false
    
    private var cloumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var spacing: CGFloat = 30.0
    
    init(coin: CoinModel) {
        self._coinDetailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
        debugPrint("DetailView Finally loaded with: \(coin.name) coin")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ChartView(coin: coinDetailViewModel.coin)
                        .padding(.vertical)
                    VStack(spacing: 8.0) {
                        coinDescription
                        overAndAdditionalInfo
                    }
                    .padding()
                }
            }
            .navigationTitle(coinDetailViewModel.coin.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarItem
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: PreviewProvider.shared.coin)
    }
}

extension DetailView {
    
    private var toolbarItem: some View {
        HStack(spacing: 4.0) {
            Button {
                // Action here
            } label: {
                Text(coinDetailViewModel.coin.symbol.uppercased())
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.secondaryTextColor)
                
                CoinImageView(coin: coinDetailViewModel.coin)
                    .frame(width: 25.0, height: 25.0)
            }
            .buttonStyle(.plain) // removes bubble styling
        }
    }
    
    @ViewBuilder
    private var coinDescription: some View {
        if let description = coinDetailViewModel.coinDetails?.description.en,
           !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(description)
                    .lineLimit(showMoreDesciption ? nil : 5)
                Text(showMoreDesciption ? "Show Less" : "Read More")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accentColor)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showMoreDesciption.toggle()
                        }
                    }
            }
            
            .onTapGesture {
                withAnimation(.easeInOut) {
                    showMoreDesciption.toggle()
                }
            }
            
        } else {
            Text("No Description available")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
        }
    }
    
    @ViewBuilder
    private var overAndAdditionalInfo: some View {
        
        Text("Overview")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        Divider()
        
        LazyVGrid(columns: cloumns, alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(coinDetailViewModel.overViewStatistics) { stats in
                StatisticView(stat: stats)
            }
        }
        
        Text("Additional Details")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        Divider()
        
        LazyVGrid(columns: cloumns, alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(coinDetailViewModel.additionalViewStatistics) { stats in
                StatisticView(stat: stats)
            }
            
        }
    }
}
