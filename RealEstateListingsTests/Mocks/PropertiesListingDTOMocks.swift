//
//  PropertiesListingDTOMocks.swift
//  RealEstateListingsTests
//
//  Created by Duy Le on 15/3/26.
//

import Foundation
@testable import RealEstateListings

@MainActor
enum PropertiesListingDTOMocks {
  static let sample: PropertiesListingDTO = decode(sampleJSON)
  static let empty: PropertiesListingDTO = decode(emptyJSON)
  static let resultWithNoStreet: PropertiesListingDTO = decode(resultWithNoStreetJSON)
  static let resultWithLocalityOnly: PropertiesListingDTO = decode(resultWithLocalityOnlyJSON)
  static let resultWithEmptyAddress: PropertiesListingDTO = decode(resultWithEmptyAddressJSON)
  static let resultWithNoRegion: PropertiesListingDTO = decode(resultWithNoRegionJSON)
  
  private static func decode(_ json: String) -> PropertiesListingDTO {
    try! JSONDecoder().decode(PropertiesListingDTO.self, from: Data(json.utf8))
  }
  
  private static let resultWithNoStreetJSON =
  #"{"from":0,"size":1,"total":1,"results":[{"id":"no-street","listing":{"id":"no-street","prices":{"currency":"CHF","buy":{"price":100000}},"address":{"country":"CH","locality":"La Brévine","postalCode":"2406","region":"NE","geoCoordinates":{"latitude":46.98,"longitude":6.6}},"localization":{"primary":"de","de":{"attachments":[],"text":{"title":"Test"},"urls":[]}}}}],"maxFrom":0}"#
  
  private static let resultWithLocalityOnlyJSON =
  #"{"from":0,"size":1,"total":1,"results":[{"id":"locality-only","listing":{"id":"locality-only","prices":{"currency":"CHF","buy":{"price":100000}},"address":{"country":"CH","locality":"Zürich","geoCoordinates":{"latitude":46.98,"longitude":6.6}},"localization":{"primary":"de","de":{"attachments":[],"text":{"title":"Test"},"urls":[]}}}}],"maxFrom":0}"#
  
  private static let resultWithEmptyAddressJSON =
  #"{"from":0,"size":1,"total":1,"results":[{"id":"empty-addr","listing":{"id":"empty-addr","prices":{"currency":"CHF","buy":{"price":100000}},"address":{"country":"CH","geoCoordinates":{"latitude":46.98,"longitude":6.6}},"localization":{"primary":"de","de":{"attachments":[],"text":{"title":"Test"},"urls":[]}}}}],"maxFrom":0}"#
  
  private static let resultWithNoRegionJSON =
  #"{"from":0,"size":1,"total":1,"results":[{"id":"no-region","listing":{"id":"no-region","prices":{"currency":"CHF","buy":{"price":100000}},"address":{"country":"CH","locality":"Lausanne","postalCode":"1000","street":"Rue Example 1","geoCoordinates":{"latitude":46.98,"longitude":6.6}},"localization":{"primary":"de","de":{"attachments":[],"text":{"title":"Test"},"urls":[]}}}}],"maxFrom":0}"#
  
  private static let emptyJSON = #"{"from":0,"size":0,"total":0,"results":[],"maxFrom":0}"#
  
  private static let sampleJSON = """
  {"from":0,"size":100,"total":9,"results":[{"id":"104123262","remoteViewing":false,"listingType":{"type":"TOP"},"listerBranding":{"logoUrl":"https://media2.homegate.ch/t_customer_logo/logos/l_heia_v1.png","legalName":"SMG Swiss Marketplace Group AG","name":"Homegate","address":{"locality":"Zürich","country":"CH","region":"ZH","street":"Werdstrasse 21","postalCode":"8004"},"adActive":true,"isQualityPartner":false,"isPremiumBranding":true,"profilePageUrlKeyword":"smg-swiss-marketplace-group-ag"},"listing":{"id":"104123262","offerType":"BUY","categories":["HOUSE","SINGLE_HOUSE"],"prices":{"currency":"CHF","buy":{"area":"ALL","price":9999999,"interval":"ONETIME"}},"address":{"country":"CH","locality":"La Brévine","postalCode":"2406","region":"NE","street":"Musterstrasse 999","geoCoordinates":{"latitude":46.980351942307,"longitude":6.606871481365}},"characteristics":{"numberOfRooms":9.5,"livingSpace":560,"lotSize":1691,"totalFloorSpace":996},"localization":{"primary":"de","de":{"attachments":[{"type":"IMAGE","url":"https://media2.homegate.ch/listings/heia/104123262/image/6b53db714891bfe2321cc3a6d4af76e1.jpg","file":"201705241056461331496.jpg"}],"text":{"title":"Luxuriöses Einfamilienhaus mit Pool - Musterinserat"},"urls":[{"type":"VIRTUAL_TOUR"},{"type":"YOUTUBE"}]}},"lister":{"phone":"+41 44 711 86 67","logoUrl":"https://media2.homegate.ch/t_customer_logo/logos/l_heia_v1.png"}}},{"id":"3001118202","remoteViewing":false,"listingType":{"type":"TOP"},"listing":{"id":"3001118202","offerType":"BUY","categories":["HOUSE","CHALET"],"prices":{"currency":"CHF","buy":{"price":9999999}},"address":{"country":"CH","locality":"La Brévine","postalCode":"2406","region":"NE","street":"Musterstrasse 999","geoCoordinates":{"latitude":46.980351942307,"longitude":6.606871481365}},"characteristics":{"numberOfRooms":9.5,"livingSpace":560,"lotSize":1691,"totalFloorSpace":996},"localization":{"primary":"de","de":{"attachments":[{"type":"IMAGE","url":"https://media2.homegate.ch/listings/hgonif/3001118202/image/98d48ffb80f47e03e03de3cbcf6e7f14.jpg","file":"a197c04ddc.jpg"}],"text":{"title":"Haus an sonniger Aussichtslage"},"urls":[]}},"lister":{"phone":"","logoUrl":""}}},{"id":"3002090762","remoteViewing":false,"listingType":{"type":"STANDARD"},"listerBranding":{"logoUrl":"https://media2.homegate.ch/t_customer_logo/logos/l_b585_v1.jpg","legalName":"Bien en Viager","address":{"locality":"Petit-Lancy","country":"CH","street":"Chemin des recluses 8","postalCode":"1213"},"adActive":false,"isQualityPartner":false,"isPremiumBranding":false,"profilePageUrlKeyword":"bien-en-viager"},"listing":{"id":"3002090762","offerType":"BUY","categories":["HOUSE","SINGLE_HOUSE"],"prices":{"currency":"CHF","buy":{"area":"ALL","price":430000}},"address":{"country":"CH","locality":"La Brévine","postalCode":"2406","region":"NE","geoCoordinates":{"latitude":46.980351942307,"longitude":6.606871481365}},"characteristics":{"numberOfRooms":8.5,"livingSpace":300,"lotSize":646,"totalFloorSpace":380},"localization":{"primary":"de","de":{"attachments":[{"type":"IMAGE","url":"https://media2.homegate.ch/listings/b585/3002090762/image/39e8aa0d414f50bdc0faf9eb03aa6e7e.jpg","file":"a13ee100d62.jpg"}],"text":{"title":"Grande maison en viager occupé sans rente"},"urls":[]}},"lister":{"phone":"022 575 66 66","logoUrl":"https://media2.homegate.ch/t_customer_logo/logos/l_b585_v1.jpg"}}}],"maxFrom":0}
  """
}
