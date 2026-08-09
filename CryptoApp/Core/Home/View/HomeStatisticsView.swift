//
//  HomeStatisticsView.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import SwiftUI

struct HomeStatisticsView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(homeViewModel.marketData, id: \.self) { stat in
                    StatisticView(stat: stat)
                        .frame(width: geometry.size.width / 3)
                }
            }
            .offset(
                x: showPortfolio
                    ? -(geometry.size.width / 3)
                    : 0
            )
            .animation(
                .easeInOut(duration: 0.4),
                value: showPortfolio
            )
        }
        .clipped()
    }
}

#Preview {
    HomeStatisticsView(showPortfolio: .constant(false))
        .environmentObject(PreviewProvider.shared.homeViewModel)
}
