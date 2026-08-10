//
//  HomeView.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import SwiftUI

struct HomeView: View {
    
    //Properties
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showPortfolio: Bool = false ///For animation right button
    @State private var showPortfolioView: Bool = false
    
    var body: some View {
        ZStack {
            //background color
            Color.theme.backgroundColor
                .ignoresSafeArea()
            
            //Content Layer
            VStack {
                homeHeader
                HomeStatisticsView(showPortfolio: $showPortfolio)
                    .frame(height: 70)
                SearchBarView(searchText: $homeViewModel.searchText)
                columnTitles
                
                if !showPortfolio {
                    altCoinlist
                        .listStyle(.plain)
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCoinlist
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
                
            }
        }
        .sheet(isPresented: $showPortfolioView) {
            PortfolioView()
                .environmentObject(homeViewModel)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(PreviewProvider.shared.homeViewModel)
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" :"info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(isAnimating: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accentColor)
                .animation(nil, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0)) ///Rotation
                .onTapGesture {
                    withAnimation { ///Animation
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var altCoinlist: some View {
        List {
            ForEach(homeViewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinlist: some View {
        List {
            ForEach(homeViewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack(spacing: 8.0) {
            Text("Coins")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Spacer()
            Text("Price")
        }
        .font(.subheadline)
        .foregroundColor(Color.theme.secondaryTextColor)
        .padding(.horizontal)
    }
}
