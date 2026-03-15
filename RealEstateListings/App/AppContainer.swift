//
//  AppContainer.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import Foundation

final class AppContainer {
  let realEstatesListingService: RealEstatesListingService
  let favoritesStorageManager: FavoritesStorageManager
  
  init() {
    let networkClient = NetworkClientImp(requestBuilder: HomegateRequestBuilder())
    self.realEstatesListingService = RealEstatesListingServiceImp(networkClient: networkClient)
    self.favoritesStorageManager = FavoritesStorageManagerImp()
  }
}
