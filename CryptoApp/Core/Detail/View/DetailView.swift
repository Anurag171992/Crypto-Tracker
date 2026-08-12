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
                VStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(
                            coinDetailViewModel.coinDetails?.description.en
                            ?? "No Description available"
                        )
                        .lineLimit(showMoreDesciption ? nil : 5)
                        
                        Text(showMoreDesciption ? "Show Less" : "Read More")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.accentColor)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showMoreDesciption.toggle()
                        }
                    }
                    
                    Text("Overview")
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundColor(Color.theme.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(columns: cloumns, alignment: .leading,
                              spacing: spacing,
                              pinnedViews: []) {
                        ForEach(0..<6) { _ in
                            StatisticView(stat: StatisticModel(title: "Title", value: "Value"))
                        }
                    }
                    
                    Text("Additional Details")
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundColor(Color.theme.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(columns: cloumns, alignment: .leading,
                              spacing: spacing,
                              pinnedViews: []) {
                        ForEach(0..<6) { _ in
                            StatisticView(stat: StatisticModel(title: "Title", value: "Value"))
                        }
                        
                    }
                }
                .padding()
            }
            .navigationTitle(coinDetailViewModel.coinDetails?.name ?? "No Name")
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: PreviewProvider.shared.coin)
    }
}
