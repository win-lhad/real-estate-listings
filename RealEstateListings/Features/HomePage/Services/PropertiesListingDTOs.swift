//
//  PropertiesListingDTOs.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Foundation

struct PropertiesListingDTO: Decodable, Equatable {
  let from: Int?
  let size: Int?
  let total: Int?
  let results: [PropertyResultDTO]
  let maxFrom: Int?
}

struct PropertyResultDTO: Decodable, Identifiable, Equatable {
  let id: String
  let remoteViewing: Bool?
  let listingType: ListingTypeDTO?
  let listerBranding: ListerBrandingDTO?
  let listing: ListingDTO
  let lister: ListerDTO?
}

struct ListingTypeDTO: Decodable, Equatable {
  let type: String
}

struct ListerBrandingDTO: Decodable, Equatable {
  let logoUrl: String?
  let legalName: String?
  let name: String?
  let address: AddressDTO?
  let adActive: Bool?
  let isQualityPartner: Bool?
  let isPremiumBranding: Bool?
  let profilePageUrlKeyword: String?
}

struct ListingDTO: Decodable, Equatable {
  let id: String
  let offerType: String?
  let categories: [String]?
  let prices: PricesDTO
  let address: AddressDTO
  let characteristics: CharacteristicsDTO?
  let localization: LocalizationDTO
  let lister: ListerDTO?
}

struct ListerDTO: Decodable, Equatable {
  let phone: String?
  let logoUrl: String?
}

struct PricesDTO: Decodable, Equatable {
  let currency: String?
  let buy: BuyPriceDTO?
}

struct BuyPriceDTO: Decodable, Equatable {
  let area: String?
  let price: Double?
  let interval: String?
}

struct AddressDTO: Decodable, Equatable {
  let country: String?
  let locality: String?
  let postalCode: String?
  let region: String?
  let street: String?
  let geoCoordinates: GeoCoordinatesDTO?
}

struct GeoCoordinatesDTO: Decodable, Equatable {
  let latitude: Double
  let longitude: Double
}

struct CharacteristicsDTO: Decodable, Equatable {
  let numberOfRooms: Double?
  let livingSpace: Double?
  let lotSize: Double?
  let totalFloorSpace: Double?
}

struct LocalizationDTO: Decodable, Equatable {
  let primary: String
  let de: LocalizationContentDTO?
}

struct LocalizationContentDTO: Decodable, Equatable {
  let attachments: [AttachmentDTO]?
  let text: LocalizationTextDTO?
  let urls: [UrlDTO]?
}

struct LocalizationTextDTO: Decodable, Equatable {
  let title: String
}

enum AttachmentTypeDTO: String, Decodable {
  case image = "IMAGE"
  case document = "DOCUMENT"
}

struct AttachmentDTO: Decodable, Equatable {
  let type: AttachmentTypeDTO
  let url: String
  let file: String?
}

struct UrlDTO: Decodable, Equatable {
  let type: String?
}
