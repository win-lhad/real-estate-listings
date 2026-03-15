//
//  AppCoordinator.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import Combine
import SwiftUI

@MainActor
final class AppCoordinator: Coordinator {
  @Published var path = NavigationPath()
  
  private let screenFactory: AppScreenFactory
  
  init(container: AppContainer) {
    self.screenFactory = AppScreenFactoryImp(container: container)
  }
  
  func makeHomePageView() -> RealEstatesListingView {
    screenFactory.makeRealEstatesListingView()
  }
}
