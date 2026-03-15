//
//  RealEstatesListingServiceMock.swift
//  RealEstateListingsTests
//
//  Created by Duy Le on 15/3/26.
//

import Foundation
@testable import RealEstateListings

final class RealEstatesListingServiceMock: RealEstatesListingService {
  var fetchPropertiesListingResult: PropertiesListingDTO?
  var fetchPropertiesListingError: Error?
  private(set) var fetchPropertiesListingCallCount = 0
  
  @MainActor func configureSuccess(with response: PropertiesListingDTO = PropertiesListingDTOMocks.sample) {
    fetchPropertiesListingResult = response
    fetchPropertiesListingError = nil
  }
  
  @MainActor func configureSuccessEmpty() {
    fetchPropertiesListingResult = PropertiesListingDTOMocks.empty
    fetchPropertiesListingError = nil
  }
  
  func configureFailure(_ error: Error) {
    fetchPropertiesListingResult = nil
    fetchPropertiesListingError = error
  }
  
  func configureFailure() {
    configureFailure(NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated failure"]))
  }
  
  func reset() {
    fetchPropertiesListingResult = nil
    fetchPropertiesListingError = nil
    fetchPropertiesListingCallCount = 0
  }
  
  func fetchPropertiesListing() async throws -> PropertiesListingDTO {
    fetchPropertiesListingCallCount += 1
    if let error = fetchPropertiesListingError {
      throw error
    }
    guard let result = fetchPropertiesListingResult else {
      throw NSError(domain: "RealEstatesListingServiceMock", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result configured. Call configureSuccess() or configureSuccessEmpty() first."])
    }
    return result
  }
}
