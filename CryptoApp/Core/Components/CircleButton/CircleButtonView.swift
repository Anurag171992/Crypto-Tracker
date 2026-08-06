//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    
    var body: some View {
       Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accentColor)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.backgroundColor)
            )
            .shadow(color: Color.theme.accentColor.opacity(0.25),radius: 10.0)
            .padding()
    }
}

#Preview {
    Group {
        CircleButtonView(iconName: "info")
            .colorScheme(.light)
            .frame(width: 50, height: 50)
        
        CircleButtonView(iconName: "plus")
            .colorScheme(.dark)
            .frame(width: 50, height: 50)
    }
    .padding()
    
}
