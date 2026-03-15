//
//  RealEstatesEndpoint.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//


import Foundation

struct HomegateRequestBuilder: RequestBuilder {
  let baseURL = URL(string: "https://private-9f1bb1-homegate3.apiary-mock.com")!
}

enum RealEstatesEndpoint: Endpoint {
  case properties
  
  var path: String {
    switch self {
    case .properties:
      return "/properties"
    }
  }
}
