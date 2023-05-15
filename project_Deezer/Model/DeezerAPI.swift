import Foundation

class DeezerAPI {
    func fetchCategories(completion: @escaping ([Category]?) -> Void) {
        guard let url = URL(string: "https://api.deezer.com/genre") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    let categories = response.data
                    completion(categories)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchArtists(for category: Category, completion: @escaping ([Artist]?) -> Void) {
        let urlString = "https://api.deezer.com/genre/\(category.id)/artists"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching artists: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ArtistsResponse.self, from: data)
                    let artists = response.data
                    completion(artists)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchAlbums(for artistId: Int, completion: @escaping ([Album]?) -> Void) {
        let urlString = "https://api.deezer.com/artist/\(artistId)/albums"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching albums: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(AlbumsResponse.self, from: data)
                    let albums = response.data
                    completion(albums)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    func fetchSongs(for albumId: Int, completion: @escaping ([Song]?) -> Void) {
        let urlString = "https://api.deezer.com/album/\(albumId)/tracks"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching songs: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SongsResponse.self, from: data)
                    let songs = response.data
                    completion(songs)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }

}
