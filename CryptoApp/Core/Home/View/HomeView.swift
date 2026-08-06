//
//  HomeView.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import SwiftUI

struct HomeView: View {
    
    //Properties
    @State private var showPortfolio: Bool = false
   
    var body: some View {
        ZStack {
            //background color
            Color.theme.backgroundColor
                .ignoresSafeArea()
            
            //Content Layer
            VStack {
                homeHeader
                Spacer(minLength: 0)

            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" :"info")
               // .animation(nil, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(isAnimating: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
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
    
}
