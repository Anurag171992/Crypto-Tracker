//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var isAnimating: Bool
    
    var body: some View {
       Circle()
            .stroke(lineWidth: 5.0)
            .scale(isAnimating ? 1.0 : 0.0) ///helps in growing
            .opacity(isAnimating ? 0.0 : 1.0) ///create a fading effect when grwoing
            .animation(isAnimating ? Animation.easeOut(duration: 1.0) : .default, value: isAnimating)
    }
}

#Preview {
    CircleButtonAnimationView(isAnimating: .constant(false))
        .foregroundColor(.red)
        .frame(width: 100, height: 100)
}
