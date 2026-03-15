//
//  FavoritesStorageManagerTests.swift
//  RealEstateListingsTests
//
//  Created by Duy Le on 15/3/26.
//

import Foundation
import Testing
@testable import RealEstateListings

@MainActor
struct FavoritesStorageManagerTests {
  
  // MARK: - Init
  
  @Test func test_init_whenEmptyUserDefaults_thenBookmarkIdsEmpty() {
    let (sut, _) = makeSUT()
    
    #expect(sut.bookmarkIds.isEmpty)
  }
  
  @Test func test_init_whenUserDefaultsHasData_thenLoadsBookmarkIds() {
    let (_, userDefaults) = makeSUT()
    userDefaults.set(["id-1", "id-2"], forKey: "bookmarked_listing_ids")
    
    let sut = FavoritesStorageManagerImp(userDefaults: userDefaults)
    
    #expect(sut.bookmarkIds == Set(["id-1", "id-2"]))
  }
  
  // MARK: - isBookmarked
  
  @Test func test_isBookmarked_whenIdNotInStore_returnsFalse() {
    let (sut, _) = makeSUT()
    
    #expect(sut.isBookmarked(id: "unknown-id") == false)
  }
  
  @Test func test_isBookmarked_whenIdInStore_returnsTrue() {
    let (sut, _) = makeSUT()
    sut.toggleBookmark(id: "listing-1")
    
    #expect(sut.isBookmarked(id: "listing-1") == true)
  }
  
  // MARK: - toggleBookmark
  
  @Test func test_toggleBookmark_whenNotBookmarked_thenAddsId() {
    let (sut, _) = makeSUT()
    
    sut.toggleBookmark(id: "listing-1")
    
    #expect(sut.isBookmarked(id: "listing-1") == true)
    #expect(sut.bookmarkIds == Set(["listing-1"]))
  }
  
  @Test func test_toggleBookmark_whenBookmarked_thenRemovesId() {
    let (sut, _) = makeSUT()
    sut.toggleBookmark(id: "listing-1")
    sut.toggleBookmark(id: "listing-2")
    
    sut.toggleBookmark(id: "listing-1")
    
    #expect(sut.isBookmarked(id: "listing-1") == false)
    #expect(sut.isBookmarked(id: "listing-2") == true)
    #expect(sut.bookmarkIds == Set(["listing-2"]))
  }
  
  @Test func test_toggleBookmark_persistsAcrossInstances() {
    let (store1, userDefaults) = makeSUT()
    store1.toggleBookmark(id: "listing-1")
    store1.toggleBookmark(id: "listing-2")
    
    let store2 = FavoritesStorageManagerImp(userDefaults: userDefaults)
    
    #expect(store2.isBookmarked(id: "listing-1") == true)
    #expect(store2.isBookmarked(id: "listing-2") == true)
    
    store2.toggleBookmark(id: "listing-1")
    
    let store3 = FavoritesStorageManagerImp(userDefaults: userDefaults)
    
    #expect(store3.isBookmarked(id: "listing-1") == false)
    #expect(store3.isBookmarked(id: "listing-2") == true)
  }
}

// MARK: - Helpers

@MainActor private func makeSUT() -> (FavoritesStorageManagerImp, UserDefaults) {
  let suiteName = UUID().uuidString
  let userDefaults = UserDefaults(suiteName: suiteName)!
  defer { userDefaults.removePersistentDomain(forName: suiteName) }
  let sut = FavoritesStorageManagerImp(userDefaults: userDefaults)
  return (sut, userDefaults)
}
