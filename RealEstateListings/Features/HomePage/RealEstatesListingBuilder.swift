//
//  RealEstatesListingBuilder.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//


import Foundation

@MainActor
final class RealEstatesListingBuilder {
  private let container: AppContainer
  
  init(container: AppContainer) {
    self.container = container
  }
  
  func build() -> RealEstatesListingView {
    let viewModel = RealEstatesListingViewModel(
      service: container.realEstatesListingService,
      favoritesStorageManager: container.favoritesStorageManager
    )
    return RealEstatesListingView(viewModel: viewModel)
  }
}
