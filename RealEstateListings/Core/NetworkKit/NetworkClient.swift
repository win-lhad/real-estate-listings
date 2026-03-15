//
//  NetworkClient.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//


import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case statusCode(Int)
  case requestFailed(Error)
  case decoding(Error)
}

protocol NetworkClient {
  func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkClientImp: NetworkClient {
  private let requestBuilder: RequestBuilder
  private let session: URLSession
  private let decoder: JSONDecoder
  
  init(requestBuilder: RequestBuilder,
       session: URLSession = .shared,
       decoder: JSONDecoder = JSONDecoder()) {
    self.requestBuilder = requestBuilder
    self.session = session
    self.decoder = decoder
  }
  
  func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
    let request = try requestBuilder.urlRequest(for: endpoint)
    
    let data: Data
    let response: URLResponse
    
    do {
      (data, response) = try await session.data(for: request)
    } catch {
      throw NetworkError.requestFailed(error)
    }
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.statusCode(httpResponse.statusCode)
    }
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decoding(error)
    }
  }
}
