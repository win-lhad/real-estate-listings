//
//  FavoritesStorageManagerMock.swift
//  RealEstateListingsTests
//
//  Created by Duy Le on 15/3/26.
//

import Combine
import Foundation
@testable import RealEstateListings

@MainActor
final class FavoritesStorageManagerMock: FavoritesStorageManager, ObservableObject {
  @Published private(set) var bookmarkIds: Set<String> = []
  private(set) var toggleBookmarkCallCount = 0
  private(set) var toggleBookmarkIds: [String] = []
  
  nonisolated init() {}
  
  func isBookmarked(id: String) -> Bool {
    bookmarkIds.contains(id)
  }
  
  func toggleBookmark(id: String) {
    toggleBookmarkCallCount += 1
    toggleBookmarkIds.append(id)
    if bookmarkIds.contains(id) {
      bookmarkIds.remove(id)
    } else {
      bookmarkIds.insert(id)
    }
  }
  
  func configureBookmarked(ids: Set<String>) {
    bookmarkIds = ids
  }
}
