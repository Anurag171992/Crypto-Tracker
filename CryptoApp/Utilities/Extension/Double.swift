//
//  Double.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation


extension Double {
    
    ///Converts a Double into currency with 2 decimal places.
    ///```
    ///Converts 1234.56 to $1,234.56
    ///```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    
    ///Converts a Double into currency as a string with 2 decimal places.
    ///```
    ///Converts 1234.56 to "$1,234.56"
    ///```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.0"
    }
    
    
    ///Converts a Double into currency with 2-6 decimal places.
    ///```
    ///Converts 1234.56 to $1,234.56
    ///Converts 12.3456 to $12.3456
    ///Converts 0.123456 to $0.123456
    ///```
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency ///converts thi 61408123 to 61,408,123
        formatter.usesGroupingSeparator = true ///<- provide , seprator
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    
    ///Converts a Double into currency as a string with 2-6 decimal places.
    ///```
    ///Converts 1234.56 to "$1,234.56"
    ///Converts 12.3456 to "$12.3456"
    ///Converts 0.123456 to "$0.123456"
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.0"
    }
    
    ///Converts a Double into String.
    ///```
    ///Converts 1.23456 to "1.23"
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    ///Converts a Double into String with % symbol.
    ///```
    ///Converts 1.23456 to "1.23%"
    ///```
    func asPercentageString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }

}
