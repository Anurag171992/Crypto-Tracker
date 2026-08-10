//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    SearchBarView(searchText: $homeViewModel.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
                .padding()
                .font(.headline)
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CrossButtonView {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.accentColor)
                }
                
                if selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) {
                    ToolbarItem(placement: .topBarTrailing) {
                        navBarItamSaveButton
                    }
                }
            }
            .onChange(of: homeViewModel.searchText) {
                if homeViewModel.searchText.isEmpty {
                    removeSelectedCoin()
                }
            }
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(PreviewProvider.shared.homeViewModel)
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10.0) {
                ForEach(homeViewModel.searchText.isEmpty ? homeViewModel.portfolioCoins : homeViewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75.0)
                        .padding(5.0)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.greenColor : Color.clear, lineWidth: 1.0)
                        )
                        .onTapGesture {
                            updateSelectedCoins(coin: coin)
                        }
                }
            }
            .frame(height: 120.0)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoins(coin: CoinModel) {
        self.selectedCoin = coin
        if let portfolioCoins = homeViewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoins.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText), let selectedCoin = self.selectedCoin {
            return quantity * selectedCoin.currentPrice
        }
        return 0
    }
    
    @ViewBuilder
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text("\(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "0")")
            }
        }
        Divider()
        HStack {
            Text("Amount holding: ")
            Spacer()
            TextField("Ex: 1.4", text: $quantityText)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
        Divider()
        HStack {
            Text("Current Value: ")
            Spacer()
            Text(getCurrentValue().asCurrencyWith2Decimals())
        }
    }
    
    
    private var navBarItamSaveButton: some View {
        HStack(alignment: .center) {
            Button {
                saveButtonPressed()
            } label: {
                Image(systemName: "checkmark")
                    .font(.subheadline)
                Text("SAVE")
                    .font(.subheadline)
            }
        }
        
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else {return}
        
        //save to portfolio
        homeViewModel.updatePortfolio(coin: coin, amount: amount)
        //show checkmark
        withAnimation {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        homeViewModel.searchText = ""
    }
}
