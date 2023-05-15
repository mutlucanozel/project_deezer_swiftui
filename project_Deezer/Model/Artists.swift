//
//  Artists.swift
//  Deneme
//
//  Created by Mutlu Can on 10.05.2023.
//

import UIKit

struct Artist: Codable, Identifiable {
    let id: Int
    let name: String
    let picture: String
    
    private enum CodingKeys: String, CodingKey {
          case id, name, picture
      }
}

struct ArtistsResponse: Codable {
    let data: [Artist]
}
