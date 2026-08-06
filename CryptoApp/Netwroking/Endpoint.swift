//
//  Endpoint.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol EndpointProtocol {
    var baseUrl: String { get }
    var path: String { get }
    var completeUrl: URL? { get }
    var method: HTTPMethod { get }
    var httpHeader: [String: String] { get }
}
