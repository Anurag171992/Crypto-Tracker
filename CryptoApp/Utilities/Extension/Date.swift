//
//  Date.swift
//  CryptoApp
//
//  Created by Anurag on 13/08/26.
//

import Foundation

extension Date {
    
    //atlDate: "2013-07-06T00:00:00.000Z"
    init(coingeckoDateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" ///Format that we are getting from String in API
        let date = formatter.date(from: coingeckoDateString) ?? Date()
        self.init(timeInterval: 0, since: date)
        
    }
    
    private var shortDateFormatter: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func asShortDate() -> String {
        return shortDateFormatter
    }
}
