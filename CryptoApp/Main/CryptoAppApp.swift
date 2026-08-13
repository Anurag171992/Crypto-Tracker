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
    @State private var showLaunchScreen = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accentColor)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle()) ///forces the iPad to have similar navigation like iPhone
                .environmentObject(homeViewModel)
                ZStack {
                    if showLaunchScreen {
                        LaunchView(showLaunchScreen: $showLaunchScreen) ///We  have kept Launch screen on NavigationStack here as we are using ZStack
                            .transition(.move(edge: .leading)) ///moves the Launch screen to left side
                    }
                }
                .zIndex(2.0) ///This ZStack is top of the Navigation View
            }
        }
    }
}
