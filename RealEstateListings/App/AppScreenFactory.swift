//
//  AppScreenFactory.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Foundation

protocol AppScreenFactory {
  func makeRealEstatesListingView() -> RealEstatesListingView
}

@MainActor
final class AppScreenFactoryImp: AppScreenFactory {
  private let container: AppContainer
  private let listingsBuilder: RealEstatesListingBuilder

  init(container: AppContainer) {
    self.container = container
    self.listingsBuilder = RealEstatesListingBuilder(container: container)
  }

  func makeRealEstatesListingView() -> RealEstatesListingView {
    return listingsBuilder.build()
  }
}
