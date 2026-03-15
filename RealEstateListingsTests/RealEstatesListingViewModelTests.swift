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
  
  @Test func test_title_whenNoTitle_returnsUntitled() async {
    let response = PropertiesListingDTOMocks.resultWithNoTitle
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let title = sut.title(for: result)
    #expect(title == "Untitled")
  }
  
  // MARK: - Formatted Price
  
  @Test func test_formattedPrice_forResultWithPrice_returnsFormattedPrice() async {
    let (_, sut) = await makeSUTWithLoadedListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let price = sut.formattedPrice(for: result)
    
    #expect(price.contains("9"))
    #expect(price.contains("CHF"))
  }
  
  @Test func test_formattedPrice_whenNoPrice_returnsDash() async {
    let response = PropertiesListingDTOMocks.resultWithNoPrice
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let price = sut.formattedPrice(for: result)
    #expect(price == "-")
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
  
  @Test func test_firstImageURL_whenNoImage_returnsNil() async {
    let response = PropertiesListingDTOMocks.resultWithNoStreet
    let (_, sut) = makeSUT { $0.configureSuccess(with: response) }
    await sut.fetchListings()
    guard let result = firstLoadedResult(from: sut) else { return }
    
    let url = sut.firstImageURL(for: result)
    #expect(url == nil)
  }
  
  // MARK: - Bookmarks
  
  @Test func test_isBookmarked_whenIdInStore_returnsTrue() async {
    let result = PropertiesListingDTOMocks.sample.results[0]
    let favoritesStorageManager = FavoritesStorageManagerMock()
    favoritesStorageManager.configureBookmarked(ids: [result.id])
    let (_, sut) = makeSUT(configure: { $0.configureSuccess() }, favoritesStorageManager: favoritesStorageManager)
    await sut.fetchListings()
    
    #expect(sut.isBookmarked(for: result) == true)
  }
  
  @Test func test_isBookmarked_whenIdNotInStore_returnsFalse() async {
    let result = PropertiesListingDTOMocks.sample.results[0]
    let favoritesStorageManager = FavoritesStorageManagerMock()
    let (_, sut) = makeSUT(configure: { $0.configureSuccess() }, favoritesStorageManager: favoritesStorageManager)
    await sut.fetchListings()
    
    #expect(sut.isBookmarked(for: result) == false)
  }
  
  @Test func test_toggleBookmark_addsIdWhenNotBookmarked() async {
    let result = PropertiesListingDTOMocks.sample.results[0]
    let favoritesStorageManager = FavoritesStorageManagerMock()
    let (_, sut) = makeSUT(configure: { $0.configureSuccess() }, favoritesStorageManager: favoritesStorageManager)
    await sut.fetchListings()
    
    sut.toggleBookmark(result)
    
    #expect(favoritesStorageManager.toggleBookmarkCallCount == 1)
    #expect(favoritesStorageManager.isBookmarked(id: result.id) == true)
  }
  
  @Test func test_toggleBookmark_removesIdWhenBookmarked() async {
    let result = PropertiesListingDTOMocks.sample.results[0]
    let favoritesStorageManager = FavoritesStorageManagerMock()
    favoritesStorageManager.configureBookmarked(ids: [result.id])
    let (_, sut) = makeSUT(configure: { $0.configureSuccess() }, favoritesStorageManager: favoritesStorageManager)
    await sut.fetchListings()
    
    sut.toggleBookmark(result)
    
    #expect(favoritesStorageManager.toggleBookmarkCallCount == 1)
    #expect(favoritesStorageManager.isBookmarked(id: result.id) == false)
  }
  
  // MARK: - Favorites Filter
  
  @Test func test_toggleFavoritesFilter_togglesState() async {
    let (_, sut) = await makeSUTWithLoadedListings()
    
    #expect(sut.isFavoritesFilterEnabled == false)
    sut.toggleFavoritesFilter()
    #expect(sut.isFavoritesFilterEnabled == true)
    sut.toggleFavoritesFilter()
    #expect(sut.isFavoritesFilterEnabled == false)
  }
  
  @Test func test_displayedListings_whenFilterOff_returnsAllListings() async {
    let listings = PropertiesListingDTOMocks.sample.results
    let (_, sut) = makeSUT { $0.configureSuccess() }
    await sut.fetchListings()
    
    let displayed = sut.displayedListings(from: listings)
    #expect(displayed == listings)
  }
  
  @Test func test_displayedListings_whenFilterOn_returnsOnlyBookmarkedListings() async {
    let listings = PropertiesListingDTOMocks.sample.results
    let bookmarkedId = listings[0].id
    let favoritesStorageManager = FavoritesStorageManagerMock()
    favoritesStorageManager.configureBookmarked(ids: [bookmarkedId])
    let (_, sut) = makeSUT(configure: { $0.configureSuccess() }, favoritesStorageManager: favoritesStorageManager)
    await sut.fetchListings()
    sut.toggleFavoritesFilter()
    
    let displayed = sut.displayedListings(from: listings)
    #expect(displayed.count == 1)
    #expect(displayed[0].id == bookmarkedId)
  }
}

// MARK: - Helpers

@MainActor private func makeSUT(configure: (RealEstatesListingServiceMock) -> Void,
                                favoritesStorageManager: FavoritesStorageManagerMock = FavoritesStorageManagerMock()) -> (RealEstatesListingServiceMock, RealEstatesListingViewModel) {
  let service = RealEstatesListingServiceMock()
  configure(service)
  let sut = RealEstatesListingViewModel(service: service, favoritesStorageManager: favoritesStorageManager)
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
