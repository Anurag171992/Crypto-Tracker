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
    @State private var showPortfolioView: Bool = false //new sheet
    @State private var showSettingsView: Bool = false //new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            //Content Layer
            VStack {
                if Secrets.coingeckoAccessToken == "put_your_coingecko_API_key_here" {
                    Text("To run the app, please enter your API key. You can get your API key from\n\n CoinGecko](https://www.coingecko.com/api/v3/\n\n Please place it in the Secrets.swift file")
                        .font(.title3)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.theme.accentColor)
                        .padding(50.0)
                    
                } else {
                    homeHeader
                    HomeStatisticsView(showPortfolio: $showPortfolio)
                        .frame(height: 70)
                    SearchBarView(searchText: $homeViewModel.searchText)
                    columnTitles
                    
                    if !showPortfolio {
                        altCoinlist
                            .listStyle(.plain)
                            .transition(.move(edge: .leading))
                    }
                    
                    if showPortfolio {
                        emptyPortfolioView
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .sheet(isPresented: $showPortfolioView) {
            PortfolioView()
                .environmentObject(homeViewModel)
        }
        .sheet(isPresented: $showSettingsView) {
            SettingView()
        }
        //Navigation to Details View
        .navigationDestination(isPresented: $showDetailView) {
            DetailLoadingView(coin: $selectedCoin)
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
                    } else {
                        showSettingsView.toggle()
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
                Button {
                    segueToDetailView(coin: coin)
                } label: {
                    CoinRowView(
                        coin: coin,
                        showHoldingColumn: false
                    )
                    .contentShape(Rectangle()) ///ensures the whole rectangular area of the row participates in hit testing
                }
                .buttonStyle(.plain)
            }
            .listRowBackground(Color.theme.backgroundColor)
        }
        .listStyle(.plain)
        .refreshable {
            homeViewModel.reloadData()
             try? await Task.sleep(for: .seconds(2))
        }
    }
    
    private var portfolioCoinlist: some View {
        List {
            ForEach(homeViewModel.portfolioCoins) { coin in
                Button {
                    segueToDetailView(coin: coin)
                } label: {
                    CoinRowView(
                        coin: coin,
                        showHoldingColumn: true
                    )
                    .contentShape(Rectangle()) ///ensures the whole rectangular area of the row participates in hit testing
                }
                .buttonStyle(.plain)
            }
            .listRowBackground(Color.theme.backgroundColor)
        }
        .listStyle(.plain)
    }
    
    private func segueToDetailView(coin: CoinModel) {
        self.selectedCoin = coin
        showDetailView.toggle()
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
    
    private var emptyPortfolioView: some View {
        ZStack(alignment: .top) {
            if homeViewModel.portfolioCoins.isEmpty && homeViewModel.searchText.isEmpty {
                Text("You have no coins in your portfolio.\nPlease add coins to your portfolio by clicking the + button 🧐")
                    .font(.callout)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.theme.accentColor)
                    .padding(50.0)
                
            } else {
                portfolioCoinlist
            }
        }
        .transition(.move(edge: .trailing))
    }
}
