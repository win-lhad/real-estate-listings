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
    Text("Real Estates Listing")
  }
}
