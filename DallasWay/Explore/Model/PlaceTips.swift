//
//  PlaceTips.swift
//  DallasWay
//
//  Created by Dharamvir Yadav on 12/21/24.
//

import Foundation

// Typealias for an array of image items
typealias PlaceTips = [PlaceTip]

// Define the struct for a single image item
struct PlaceTip: Codable {
    let id: String
    let createdAt: String
    let text: String

    // Custom coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case text
    }
}
