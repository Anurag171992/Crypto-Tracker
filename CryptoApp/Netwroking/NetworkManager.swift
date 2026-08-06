//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation

protocol NetworkingProtocol {
    func requestData<T: Decodable & Sendable>(modelType: T.Type, endPoint: EndpointProtocol) async throws -> T
}

class NetworkManager: NetworkingProtocol {
    
    private let jsonDecoder = JSONDecoder()
    
    // Performs a generic API request and decodes the response.
    /// - Parameter modelType: The `Decodable & Sendable` type to decode the response and safely pass types across concurrency boundaries.
    /// - Parameter endPoint: The endpoint conforming to `EndpointProtocol` that defines URL, method, and headers.
    /// - Returns: A decoded instance of the specified model type.
    /// - Throws: Errors such as `invalidURL`, `invalidResponse`, `unauthorized`, `notFound`, `serverError`, or `decoding` if the request fails.
    func requestData<T: Decodable & Sendable>(modelType: T.Type, endPoint: EndpointProtocol) async throws -> T {
        guard let url = endPoint.completeUrl else {
            throw DataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.httpHeader
        jsonDecoder.dateDecodingStrategy = .iso8601 ///It ensures automatic conversion from JSON string to Swift date
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw DataError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw DataError.unauthorized
        case 404:
            throw DataError.notFound
        case 500...599:
            throw DataError.serverError(httpResponse.statusCode)
        default:
            throw DataError.invalidResponse
        }
        do {
            let decoded = try jsonDecoder.decode(modelType.self, from: data)
            return decoded
        } catch {
            throw DataError.decoding(error)
        }
    }
}
