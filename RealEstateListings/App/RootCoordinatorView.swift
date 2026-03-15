//
//  RootCoordinatorView.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import SwiftUI

struct RootCoordinatorView: View {
  @ObservedObject var coordinator: AppCoordinator
  
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      coordinator.makeHomePageView()
    }
  }
}
