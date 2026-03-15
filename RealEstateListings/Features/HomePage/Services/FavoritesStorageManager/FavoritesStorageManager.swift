//
//  FavoritesStorageManager.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Combine
import Foundation

protocol FavoritesStorageManager: AnyObject {
  var bookmarkIds: Set<String> { get }
  func isBookmarked(id: String) -> Bool
  func toggleBookmark(id: String)
}

@MainActor
final class FavoritesStorageManagerImp: FavoritesStorageManager, ObservableObject {
  @Published private(set) var bookmarkIds: Set<String>
  
  private let userDefaults: UserDefaults
  private let storageKey = "bookmarked_listing_ids"
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    let array = userDefaults.stringArray(forKey: storageKey) ?? []
    self.bookmarkIds = Set(array)
  }
  
  func isBookmarked(id: String) -> Bool {
    bookmarkIds.contains(id)
  }
  
  func toggleBookmark(id: String) {
    if bookmarkIds.contains(id) {
      bookmarkIds.remove(id)
    } else {
      bookmarkIds.insert(id)
    }
    userDefaults.set(Array(bookmarkIds), forKey: storageKey)
  }
}
