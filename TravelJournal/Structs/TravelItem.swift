//
//  TravelItem.swift
//  TravelJournal
//
//  Created by GradByte on 12.01.2024.
//

import Foundation

struct TravelItem: Identifiable, Codable {
    let id: UUID
    var country: String
    var city: String
    var type = "Business"
    var photo: Data?
    var note: String
    
    // Explicitly define CodingKeys enum to silence the id warning
    enum CodingKeys: String, CodingKey {
        case id
        case country
        case city
        case type
        case photo
        case note
    }
    
    init(country: String, city: String, type: String = "Business", photo: Data? = nil, note: String) {
        self.id = UUID()
        self.country = country
        self.city = city
        self.type = type
        self.photo = photo
        self.note = note
    }
}
