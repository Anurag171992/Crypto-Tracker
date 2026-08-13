//
//  CrossButtonView.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import SwiftUI

struct CrossButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}
#Preview {
    CrossButtonView {}
}
