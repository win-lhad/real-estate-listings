//
//  RealEstatesListingView.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import SwiftUI

struct RealEstatesListingView: View {
  @StateObject private var viewModel: RealEstatesListingViewModel
  
  init(viewModel: RealEstatesListingViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    Group {
      switch viewModel.state {
      case .idle:
        Color.clear
      case .loading:
        ProgressView()
      case .loaded(let listings):
        let displayed = viewModel.displayedListings(from: listings)
        Group {
          if displayed.isEmpty {
            ContentUnavailableView(
              viewModel.isFavoritesFilterEnabled ? "No favorites yet" : "No listings available",
              systemImage: viewModel.isFavoritesFilterEnabled ? "heart.slash" : "tray",
              description: Text(
                viewModel.isFavoritesFilterEnabled
                ? "Tap the heart on a listing to add it to your favorites."
                : "Check back later for new listings."
              )
            )
          } else {
            List {
              ForEach(displayed) { result in
                PropertyCard(
                  title: viewModel.title(for: result),
                  price: viewModel.formattedPrice(for: result),
                  address: viewModel.formattedAddress(for: result),
                  imageURL: viewModel.firstImageURL(for: result),
                  isBookmarked: viewModel.isBookmarked(for: result),
                  onLikeTapped: { viewModel.toggleBookmark(result) }
                )
              }
            }
            .listStyle(.plain)
          }
        }
      case .failed(let message):
        VStack(spacing: 16) {
          Text(message)
            .font(.subheadline)
            .foregroundStyle(.secondary)
          Button("Refresh") {
            Task { await viewModel.fetchListings() }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("REL")
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          viewModel.toggleFavoritesFilter()
        } label: {
          Image(systemName: viewModel.isFavoritesFilterEnabled ? "heart.circle.fill" : "heart.circle")
        }
        .disabled(viewModel.state.loadedValue == nil)
      }
    }
    .task {
      if case .idle = viewModel.state {
        await viewModel.fetchListings()
      }
    }
  }
}
