//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Anurag on 06/08/26.
//

import Foundation
import Combine

protocol NetworkingProtocol {
    func requestData<T: Decodable & Sendable>(modelType: T.Type, endPoint: EndpointProtocol) async throws -> T
    func requestDataCombine<T: Decodable>(modelType: T.Type, endPoint: EndpointProtocol) -> AnyPublisher<T, Error>
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
            throw DataError.invalidResponse(url: url)
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
            throw DataError.invalidResponse(url: url)
        }
        do {
            let decoded = try jsonDecoder.decode(modelType.self, from: data)
            return decoded
        } catch {
            throw DataError.decoding(error)
        }
    }
    
    func requestDataCombine<T: Decodable>(modelType: T.Type, endPoint: EndpointProtocol) -> AnyPublisher<T, Error> {

        guard let url = endPoint.completeUrl else {
            return Fail(error: DataError.invalidURL)
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.httpHeader

        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))

            .tryMap { output in
                try self.handleURLResponse(
                    output: output,
                    url: url
                )
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Combine + URLSession
    func downloadData(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            /// Determines where the upstream work should be performed.
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            
            /// Validates the HTTP response and returns the response data.
            .tryMap { output in
                try self.handleURLResponse(
                    output: output,
                    url: url
                )
            }
            
            /// Tells Combine to deliver downstream values on the Main thread.
            .receive(on: DispatchQueue.main)
            
            /// Hides the concrete publisher type.
            .eraseToAnyPublisher()
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw DataError.invalidResponse(url: url)
        }
        
        switch response.statusCode {
        case 200...299:
            return output.data
            
        case 401:
            throw DataError.unauthorized
            
        case 404:
            throw DataError.notFound
            
        case 500...599:
            throw DataError.serverError(response.statusCode)
            
        default:
            throw DataError.invalidResponse(url: url)
        }
    }
    
    
    ///MainActor becuase in sink the completion is handler is checked on actor isolation
    ///The completion handler may interact with UI-related state or be called from a context where actor isolation is checked.
    ///@MainActor tells Swift that this method should execute on the main actor, satisfying Swift 6's actor isolation rules and ensuring any UI-related work is performed safely.
    /// This is complie time instruction and hence at complie time it removes the warning ///This tells compiler to send values on Main Actor
    @MainActor
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            debugPrint(error)
        }
    }
    
    ///DispatchQueue.main tells weher to execute i.e Main Thread
    ///@MainActor tells which actors ownership the execution is allowed
}
