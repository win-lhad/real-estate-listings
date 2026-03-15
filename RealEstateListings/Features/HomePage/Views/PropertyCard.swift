//
//  PropertyCard.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import SwiftUI

struct PropertyCard: View {
  let title: String
  let price: String
  let address: String
  let imageURL: URL?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      ZStack(alignment: .bottomLeading) {
        AsyncImage(url: imageURL) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
          case .failure:
            Color.gray.opacity(0.3)
          case .empty:
            Color.gray.opacity(0.2)
          @unknown default:
            Color.gray.opacity(0.2)
          }
        }
        .frame(height: 200)
        .clipped()
        
        Text(price)
          .font(.headline)
          .fontWeight(.bold)
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .background(.white)
          .overlay(
            RoundedRectangle(cornerRadius: 4)
              .stroke(.black, lineWidth: 1)
          )
          .padding(12)
      }
      
      Text(title)
        .font(.headline)
        .fontWeight(.semibold)
        .lineLimit(2)
      
      HStack(spacing: 6) {
        Image(systemName: "mappin.circle.fill")
          .foregroundStyle(.teal)
          .font(.subheadline)
        Text(address)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(2)
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color(.separator), lineWidth: 0.5)
    )
    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }
}
