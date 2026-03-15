//
//  RealEstatesListingService.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import Foundation

protocol RealEstatesListingService {
  func fetchPropertiesListing() async throws -> PropertiesListingDTO
}

final class RealEstatesListingServiceImp: RealEstatesListingService {
  private let networkClient: NetworkClient
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  func fetchPropertiesListing() async throws -> PropertiesListingDTO {
    try await networkClient.send(RealEstatesEndpoint.properties)
  }
}
