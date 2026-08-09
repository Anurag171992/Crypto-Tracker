//
//  StatisticModel.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import Foundation

struct StatisticModel: Identifiable, Hashable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
