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
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ChartView(coin: coinDetailViewModel.coin)
                        .padding(.vertical)
                    VStack(spacing: 8.0) {
                        overAndAdditionalInfo
                        websiteSection
                    }
                    .padding()
                }
            }
            .background(
                Color.theme.backgroundColor
                    .ignoresSafeArea()
            )
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
        if let description = coinDetailViewModel.coinDescription,
           !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        
            VStack(alignment: .leading, spacing: 8) {
                Text(description)
                    .lineLimit(showMoreDesciption ? nil : 3)
                Text(showMoreDesciption ? "Show Less" : "Read More")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
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
        ZStack {
            coinDescription
        }
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
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            if let websiteURL = coinDetailViewModel.websiteURL,
               let url = URL(string: websiteURL) {
                Link("Website", destination: url)
            }
            
            if let whitePaperURL = coinDetailViewModel.whitePaperURL,
               let url = URL(string: whitePaperURL) {
                Link("Whitepaper", destination: url)
            }
            
            if let redditURL = coinDetailViewModel.subRedditURL,
               let url = URL(string: redditURL) {
                Link("Reddit", destination: url)
            }
            
        }
        .font(.headline)
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
