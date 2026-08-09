//
//  APIError.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation

enum DataError: LocalizedError {
    case invalidURL
    case unauthorized        //401
    case notFound            //404
    case serverError(Int)    //5xx or other codes
    case invalidResponse(url: URL)
    case decoding(Error?)
    case network(Error?)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "🔗 Invalid URL"
        case .unauthorized:
            return "🔒 Unauthorized request (401)"
        case .notFound:
            return "🔍 Resource not found (404)"
        case .serverError(let code):
            return "🔥 Internal Server Error (\(code))"
        case .invalidResponse(url: let url):
            return "⚠️ Invalid server response: \(url)"
        case .decoding(let error):
            return "📦 Decoding failed: \(error?.localizedDescription ?? "Unknown error")"
        case .network(let error):
            return "🌐 Network error: \(error?.localizedDescription ?? "Unknown error")"
        }
    }
}

