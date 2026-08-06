//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}
