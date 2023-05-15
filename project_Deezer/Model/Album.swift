//
//  Album.swift

//  Created by Mutlu Can on 10.05.2023.
//

import UIKit
struct Album: Codable, Identifiable {
    let id: Int
    let title: String
    let cover: String
    let releaseDate: String

    var formattedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
        
        return releaseDate
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, cover = "cover_medium", releaseDate = "release_date"
    }
}
struct AlbumsResponse: Codable {
    let data: [Album]
}

