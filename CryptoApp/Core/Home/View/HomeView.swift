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
        .refreshable {
            homeViewModel.reloadData()
            // try? await Task.sleep(for: .seconds(2))
            await withCheckedContinuation { continuation in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    continuation.resume()
                }
            }
        }
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
        HStack {
            HStack(spacing: 4.0) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity((homeViewModel.sortOption == .rank || homeViewModel.sortOption == .rankRerversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .rank ? .rankRerversed : .rank
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack(spacing: 4.0) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((homeViewModel.sortOption == .holding || homeViewModel.sortOption == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: homeViewModel.sortOption == .holding ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        homeViewModel.sortOption = homeViewModel.sortOption == .holding ? .holdingReversed : .holding
                    }
                }
            }
            
            Spacer()
            HStack(spacing: 4.0) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((homeViewModel.sortOption == .price || homeViewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(Color.theme.secondaryTextColor)
        .padding(.horizontal)
    }
}
