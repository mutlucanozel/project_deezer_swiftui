import Foundation

struct Song: Codable, Identifiable {
    let id: Int
    let title: String
    let duration: Int
    let previewURL: String
    let md5_image: String
    var imageURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case duration
        case previewURL = "preview"
        case md5_image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        duration = try container.decode(Int.self, forKey: .duration)
        previewURL = try container.decode(String.self, forKey: .previewURL)
        md5_image = try container.decode(String.self, forKey: .md5_image)
        imageURL = nil
    }
}

struct SongsResponse: Codable {
    let data: [Song]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
