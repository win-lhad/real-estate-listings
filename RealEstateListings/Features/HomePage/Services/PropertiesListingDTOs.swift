//
//  PropertiesListingDTOs.swift
//  RealEstateListings
//
//  Created by Duy Le on 15/3/26.
//

import Foundation

struct PropertiesListingDTO: Decodable {
  let from: Int?
  let size: Int?
  let total: Int?
  let results: [PropertyResultDTO]
  let maxFrom: Int?
}

struct PropertyResultDTO: Decodable, Identifiable {
  let id: String
  let remoteViewing: Bool?
  let listingType: ListingTypeDTO?
  let listerBranding: ListerBrandingDTO?
  let listing: ListingDTO
  let lister: ListerDTO?
}

struct ListingTypeDTO: Decodable {
  let type: String
}

struct ListerBrandingDTO: Decodable {
  let logoUrl: String?
  let legalName: String?
  let name: String?
  let address: AddressDTO?
  let adActive: Bool?
  let isQualityPartner: Bool?
  let isPremiumBranding: Bool?
  let profilePageUrlKeyword: String?
}

struct ListingDTO: Decodable {
  let id: String
  let offerType: String?
  let categories: [String]?
  let prices: PricesDTO
  let address: AddressDTO
  let characteristics: CharacteristicsDTO?
  let localization: LocalizationDTO
  let lister: ListerDTO?
}

struct ListerDTO: Decodable {
  let phone: String?
  let logoUrl: String?
}

struct PricesDTO: Decodable {
  let currency: String?
  let buy: BuyPriceDTO?
  let rent: RentPriceDTO?
}

struct BuyPriceDTO: Decodable {
  let area: String?
  let price: Double?
  let interval: String?
}

struct RentPriceDTO: Decodable {
}

struct AddressDTO: Decodable {
  let country: String?
  let locality: String?
  let postalCode: String?
  let region: String?
  let street: String?
  let geoCoordinates: GeoCoordinatesDTO?
}

struct GeoCoordinatesDTO: Decodable {
  let latitude: Double
  let longitude: Double
}

struct CharacteristicsDTO: Decodable {
  let numberOfRooms: Double?
  let livingSpace: Double?
  let lotSize: Double?
  let totalFloorSpace: Double?
}

struct LocalizationDTO: Decodable {
  let primary: String
  let de: LocalizationContentDTO?
}

struct LocalizationContentDTO: Decodable {
  let attachments: [AttachmentDTO]?
  let text: LocalizationTextDTO?
  let urls: [UrlDTO]?
}

struct LocalizationTextDTO: Decodable {
  let title: String
}

enum AttachmentTypeDTO: String, Decodable {
  case image = "IMAGE"
  case document = "DOCUMENT"
}

struct AttachmentDTO: Decodable {
  let type: AttachmentTypeDTO
  let url: String
  let file: String?
}

struct UrlDTO: Decodable {
  let type: String?
}
