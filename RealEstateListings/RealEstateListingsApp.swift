//
//  RealEstateListingsApp.swift
//  RealEstateListings
//
//  Created by Duy Le on 13/3/26.
//

import SwiftUI

@main
struct RealEstateListingsApp: App {
  @StateObject private var coordinator: AppCoordinator
  
  init() {
    let container = AppContainer()
    _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
  }
  
  var body: some Scene {
    WindowGroup {
      RootCoordinatorView(coordinator: coordinator)
    }
  }
}
