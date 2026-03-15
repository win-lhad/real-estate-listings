//
//  RealEstatesListingViewModel.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Combine
import Foundation

@MainActor
final class RealEstatesListingViewModel: ObservableObject {
  @Published private(set) var title = "Real Estates Listing"

  private let service: RealEstatesListingService

  init(service: RealEstatesListingService) {
    self.service = service
  }
}
