//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Anurag on 12/08/26.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func generate() {
        generator.notificationOccurred(.success)
    }
}
