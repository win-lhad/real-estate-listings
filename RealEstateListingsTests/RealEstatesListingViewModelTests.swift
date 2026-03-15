//
//  RealEstatesListingViewModelTests.swift
//  RealEstateListingsTests
//
//  Created by Duy Le on 15/3/26.
//

import Foundation
import Testing
@testable import RealEstateListings

@MainActor
struct RealEstatesListingViewModelTests {
  
  // MARK: - Fetch Listings
  
  @Test func test_fetchListings_whenServiceSucceeds_thenUpdatesStateToLoaded() async {
    let (service, sut) = makeSUT { $0.configureSuccess() }
    await sut.fetchListings()
    
    assertLoadedState(sut: sut, expectedListings: PropertiesListingDTOMocks.sample.results)
    assertServiceCallCount(service: service, expected: 1)
  }
  
  @Test func test_fetchListings_whenServiceSucceedsWithEmptyResults_thenUpdatesStateToLoadedWithEmptyArray() async {
    let (service, sut) = makeSUT { $0.configureSuccessEmpty() }
    await sut.fetchListings()
    
    assertLoadedState(sut: sut, expectedListings: [])
    assertServiceCallCount(service: service, expected: 1)
  }
  
  @Test func test_fetchListings_whenServiceFails_thenUpdatesStateToFailed() async {
    let (service, sut) = makeSUT { $0.configureFailure() }
    await sut.fetchListings()
    
    assertFailedState(sut: sut, expectedMessage: "Failed to load listings.")
    assertServiceCallCount(service: service, expected: 1)
  }
  
  // MARK: - Title
  
  @Test func test_title_forResultWithTitle_returnsTitle() async {
    let (_, sut) = await makeSUTWithLoadedListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let title = sut.title(for: result)
    
    #expect(title == "Luxuriöses Einfamilienhaus mit Pool - Musterinserat")
  }
  
  // MARK: - Formatted Price
  
  @Test func test_formattedPrice_forResultWithPrice_returnsFormattedPrice() async {
    let (_, sut) = await makeSUTWithLoadedListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let price = sut.formattedPrice(for: result)
    
    #expect(price.contains("9"))
    #expect(price.contains("CHF"))
  }
  
  // MARK: - Formatted Address
  
  @Test func test_formattedAddress_whenAllFieldsPresent_returnsStreetPostalCodeLocalityAndRegion() async {
    let (_, sut) = await makeSUTWithLoadedListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let address = sut.formattedAddress(for: result)
    
    #expect(address.contains("Musterstrasse 999"))
    #expect(address.contains("2406 La Brévine"))
    #expect(address.contains("NE"))
  }
  
  @Test func test_formattedAddress_whenNoStreet_returnsPostalCodeLocalityAndRegion() async {
    let response = PropertiesListingDTOMocks.resultWithNoStreet
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let address = sut.formattedAddress(for: result)
    
    #expect(address == "2406 La Brévine, NE")
  }
  
  @Test func test_formattedAddress_whenOnlyLocality_returnsLocalityOnly() async {
    let response = PropertiesListingDTOMocks.resultWithLocalityOnly
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let address = sut.formattedAddress(for: result)
    
    #expect(address == "Zürich")
  }
  
  @Test func test_formattedAddress_whenAllAddressFieldsEmpty_returnsEmptyString() async {
    let response = PropertiesListingDTOMocks.resultWithEmptyAddress
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let address = sut.formattedAddress(for: result)
    
    #expect(address.isEmpty)
  }
  
  @Test func test_formattedAddress_whenNoRegion_returnsStreetPostalCodeAndLocality() async {
    let response = PropertiesListingDTOMocks.resultWithNoRegion
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let address = sut.formattedAddress(for: result)
    
    #expect(address.contains("Rue Example 1"))
    #expect(address.contains("1000 Lausanne"))
    #expect(!address.contains(", ,"))
  }
  
  // MARK: - First Image URL
  
  @Test func test_firstImageURL_forResultWithImage_returnsURL() async {
    let (_, sut) = await makeSUTWithLoadedListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let url = sut.firstImageURL(for: result)
    
    #expect(url != nil)
    #expect(url?.absoluteString.contains("media2.homegate.ch") == true)
  }
}

// MARK: - Helpers

@MainActor private func makeSUT(configure: (RealEstatesListingServiceMock) -> Void) -> (RealEstatesListingServiceMock, RealEstatesListingViewModel) {
  let service = RealEstatesListingServiceMock()
  configure(service)
  let sut = RealEstatesListingViewModel(service: service)
  return (service, sut)
}

@MainActor private func makeSUTWithLoadedListings() async -> (RealEstatesListingServiceMock, RealEstatesListingViewModel) {
  let (service, sut) = makeSUT { $0.configureSuccess() }
  await sut.fetchListings()
  return (service, sut)
}

@MainActor private func firstLoadedResult(from sut: RealEstatesListingViewModel) -> PropertyResultDTO? {
  guard case .loaded(let listings) = sut.state else {
    Issue.record("Expected loaded state")
    return nil
  }
  guard let result = listings.first else {
    Issue.record("Expected at least one listing")
    return nil
  }
  return result
}

@MainActor private func assertLoadedState(sut: RealEstatesListingViewModel, expectedListings: [PropertyResultDTO]) {
  guard case .loaded(let listings) = sut.state else {
    Issue.record("Expected loaded state")
    return
  }
  #expect(listings == expectedListings)
}

@MainActor private func assertFailedState(sut: RealEstatesListingViewModel, expectedMessage: String) {
  guard case .failed(let message) = sut.state else {
    Issue.record("Expected failed state")
    return
  }
  #expect(message == expectedMessage)
}

private func assertServiceCallCount(service: RealEstatesListingServiceMock, expected: Int) {
  #expect(service.fetchPropertiesListingCallCount == expected)
}
