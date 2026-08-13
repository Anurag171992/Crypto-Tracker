//
//  ChartView.swift
//  CryptoApp
//
//  Created by Anurag on 13/08/26.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let minY: Double
    private let maxY: Double
    private let midY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        minY = data.min() ?? 0 ///min Value = btc = 50000
        maxY = data.max() ?? 0 ///max Value = btc = 60000
        midY = maxY + minY
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange < 0 ? Color.theme.redColor : Color.theme.greenColor
        endingDate = Date(coingeckoDateString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) ///negative represents going 7 days earlier and this is in seconds as 7- days, 24 - hours, 60 - mins, 60 - seconds
    }
    
    var body: some View {
        VStack {
            chartPresenter
                .frame(height: 200.0)
                .background(
                    backGroundDivider
                )
            ///adds on the chart
                .overlay(chartYaxis
                    .padding(.horizontal, 4.0), alignment: .leading)
            dateInterval7
                .padding(.top, 4.0)
                .padding(.horizontal, 4.0)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryTextColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin: PreviewProvider.shared.coin)
}

extension ChartView {
    
    //300
    //100
    //3
    // 1 * 3 = 3
    // 2 * 3 = 6
    // 100 * 3 = 300 - width of chart for x axis
    
    //60,000
    //50,000
    //60,000 - 50,000 = 10,000 - Points for yaxis - let yAxis = maxY - minY
    //52,000 - Data point
    //52,000 - 50,000 = 2,000 / 10,000 = 20% - let yPosition = (data[index] - minY) / yAxis * geometry.size.height
    //geometry.size.height = 20% * actual height
    
    private var chartPresenter: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height /// 1 - = inverses the chart as our cordinate starts with 0,0
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            ///creates the line end to end as percentage is set to 1.0 onAppear
            .trim(from: 0.0, to: percentage)
            ///creates line
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            ///y = creates a shadow downwards
            .shadow(color: lineColor, radius: 10.0, x: 0.0, y: 10.0)
            .shadow(color: lineColor.opacity(0.5), radius: 10.0, x: 0.0, y: 20.0)
        }
    }
    
    private var backGroundDivider: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYaxis : some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(midY.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var dateInterval7: some View {
        HStack {
            Text("\(startingDate.asShortDate())")
                .font(.system(size: 10))
                .foregroundColor(Color.theme.secondaryTextColor)
            Spacer()
            Text("\(endingDate.asShortDate())")
                .font(.system(size: 10))
                .foregroundColor(Color.theme.secondaryTextColor)
        }
    }
}

