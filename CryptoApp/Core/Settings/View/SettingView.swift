//
//  SettingView.swift
//  CryptoApp
//
//  Created by Anurag on 13/08/26.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundColor
                    .ignoresSafeArea()
                
                List {
                    developerInfoSection
                        .listRowBackground(Color.theme.backgroundColor.opacity(0.5))
                    coingeckoSection
                        .listRowBackground(Color.theme.backgroundColor.opacity(0.5))
                }
                .scrollContentBackground(.hidden) // hides default background
                .background(Color.theme.backgroundColor) // applies your custom background
            }
            .navigationTitle("Settings")
            .font(.headline)
            .tint(.blue)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CrossButtonView {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}

extension SettingView {

    private var developerInfoSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    Link("Developer LinkedIn Profile", destination: Constants.linedInProfile!)
                        .tint(.blue)
                        .font(.headline)
                }
                
                Text("The application fetches real-time cryptocurrency market data and allows users to search, monitor, and manage their crypto portfolio. The project focuses on clean architecture, modern Swift development practices, and reactive programming using Combine. To save Porfolio data, CoreData is used for persistence.")
                    .font(.subheadline)
            }
        }
    }

    private var coingeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading, spacing: 12.0) {
                
                Link("Visit CoinGecko for API's 🦎", destination: Constants.coingecko!)
                    .tint(.blue)
                
                HStack {
                    Image("coingecko")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                }
                
                Text("CoinGecko is the world's largest independent cryptocurrency data aggregator that tracks real-time prices, trading volume, market capitalization, and developer activity across thousands of digital assets")
                    .font(.subheadline)
                
                Text("The Cyrptocurrency data is provided by CoinGecko which is coming from a free API that is open to anyone. CoinGecko is a non-profit organization that is dedicated to making financial markets more open and transparent.")
                    .font(.subheadline)
            }
        }
    }
}
