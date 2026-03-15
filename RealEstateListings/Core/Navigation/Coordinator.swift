//
//  Coordinator.swift
//  RealEstateListings
//
//  Created by Duy Le on 14/3/26.
//

import Combine
import SwiftUI

@MainActor
protocol Coordinator: ObservableObject {
  var path: NavigationPath { get set }
  func navigate(to route: any Hashable)
  func pop()
  func popToRoot()
}

extension Coordinator {
  func navigate(to route: any Hashable) {
    path.append(route)
  }
  
  func pop() {
    guard !path.isEmpty else {
      return
    }
    path.removeLast()
  }
  
  func popToRoot() {
    path = NavigationPath()
  }
}
