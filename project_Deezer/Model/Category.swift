//
//  Category.swift
//  Deneme
//
//  Created by Mutlu Can on 10.05.2023.
//

import UIKit

import Foundation

struct Category: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let picture: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, picture = "picture_small"
    }
}
struct Response: Codable {
    let data: [Category]
}
