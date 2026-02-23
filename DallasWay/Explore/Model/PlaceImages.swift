//
//  PlaceImages.swift
//  DallasWay
//
//  Created by Dharamvir Yadav on 12/21/24.
//

import Foundation

// Typealias for an array of image items
typealias PlaceImages = [PlaceImage]

// Define the struct for a single image item
struct PlaceImage: Codable {
    let id: String
    let createdAt: String
    let prefix: String
    let suffix: String
    
    var url: String {
        prefix + "original" + suffix
    }

    // Custom coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case prefix
        case suffix
    }
}

