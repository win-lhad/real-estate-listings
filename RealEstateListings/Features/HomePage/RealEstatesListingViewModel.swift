//
//  RealEstatesListingViewModel.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Combine
import Foundation

@MainActor
final class RealEstatesListingViewModel: ObservableObject {
  @Published private(set) var state: LoadableState<[PropertyResultDTO], String> = .idle
  
  private let service: RealEstatesListingService
  
  init(service: RealEstatesListingService) {
    self.service = service
  }
  
  func fetchListings() async {
    state = .loading
    
    do {
      let response = try await service.fetchPropertiesListing()
      state = .loaded(response.results)
    } catch {
      state = .failed("Failed to load listings.")
    }
  }
  
  func title(for result: PropertyResultDTO) -> String {
    result.listing.localization.de?.text?.title ?? "Untitled"
  }
  
  func formattedPrice(for result: PropertyResultDTO) -> String {
    let prices = result.listing.prices
    guard let amount = prices.buy?.price else { return "-" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = prices.currency ?? "CHF"
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
  }
  
  func formattedAddress(for result: PropertyResultDTO) -> String {
    let address = result.listing.address
    let firstLine = [address.street].compactMap { $0 }.joined(separator: ", ")
    let secondLine = [address.postalCode, address.locality].compactMap { $0 }.joined(separator: " ")
    let state = address.region ?? ""
    return [firstLine, secondLine, state]
      .filter { !$0.isEmpty }
      .joined(separator: ", ")
  }
  
  func firstImageURL(for result: PropertyResultDTO) -> URL? {
    result.listing.localization.de?
      .attachments?
      .first { $0.type == .image }
      .flatMap { URL(string: $0.url) }
  }
}
