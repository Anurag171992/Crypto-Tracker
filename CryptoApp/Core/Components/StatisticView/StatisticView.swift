//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import Foundation
import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accentColor)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.percentageChange?.asPercentageString() ?? " ")
                    .font(.caption)
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.greenColor : Color.theme.redColor)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        StatisticView(stat: PreviewProvider.shared.statisticModel1)
            .colorScheme(.light)
        StatisticView(stat: PreviewProvider.shared.statisticModel2)
            .colorScheme(.dark)
        StatisticView(stat: PreviewProvider.shared.statisticModel3)
            .colorScheme(.light)
    }
}
