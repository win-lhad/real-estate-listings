//
//  AppContainer.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import Foundation

final class AppContainer {
  let realEstatesListingService: RealEstatesListingService
  
  init(realEstatesListingService: RealEstatesListingService? = nil) {
    if let realEstatesListingService {
      self.realEstatesListingService = realEstatesListingService
      return
    }
    let networkClient = NetworkClientImp(requestBuilder: HomegateRequestBuilder())
    self.realEstatesListingService = RealEstatesListingServiceImp(networkClient: networkClient)
  }
}
