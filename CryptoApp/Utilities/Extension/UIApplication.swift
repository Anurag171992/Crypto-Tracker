//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
