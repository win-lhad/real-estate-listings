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
        List {
          ForEach(listings) { result in
            PropertyCard(
              title: viewModel.title(for: result),
              price: viewModel.formattedPrice(for: result),
              address: viewModel.formattedAddress(for: result),
              imageURL: viewModel.firstImageURL(for: result)
            )
          }
        }
        .listStyle(.plain)
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
    .task {
      if case .idle = viewModel.state {
        await viewModel.fetchListings()
      }
    }
  }
}
