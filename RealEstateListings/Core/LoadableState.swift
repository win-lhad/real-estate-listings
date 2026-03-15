//
//  LoadableState.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Foundation

enum LoadableState<Value: Equatable, Failure: Equatable>: Equatable {
  case idle
  case loading
  case loaded(Value)
  case failed(Failure)
  
  var loadedValue: Value? {
    if case .loaded(let value) = self { return value }
    return nil
  }
}
