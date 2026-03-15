//
//  RealEstateListingServiceImp.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import Foundation

protocol RealEstateListingService {
  func fetchListings() async throws -> [RealEstate]
}

final class RealEstateListingServiceImp: RealEstateListingService {
  func fetchListings() async throws -> [RealEstate] {
    []
  }
}
