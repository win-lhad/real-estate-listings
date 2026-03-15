//
//  RequestBuilder.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//


import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol Endpoint {
  var path: String { get }
  var method: HTTPMethod { get }
  var queryItems: [URLQueryItem]? { get }
  var headers: [String: String]? { get }
}

extension Endpoint {
  var method: HTTPMethod { .get }
  var queryItems: [URLQueryItem]? { nil }
  var headers: [String: String]? { nil }
}

protocol RequestBuilder {
  var baseURL: URL { get }
  func urlRequest(for endpoint: Endpoint) throws -> URLRequest
}

extension RequestBuilder {
  func urlRequest(for endpoint: Endpoint) throws -> URLRequest {
    guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
      throw NetworkError.invalidURL
    }
    
    components.path = endpoint.path
    components.queryItems = endpoint.queryItems
    
    guard let url = components.url else {
      throw NetworkError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    return request
  }
}
