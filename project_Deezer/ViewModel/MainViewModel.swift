import SwiftUI


class MainViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var selectedTab = 0
    @Published var selectedCategory: Category?
    @Published var artists: [Artist] = []
    @Published var albums: [Album] = []
    @Published var songs: [Song] = []
    @Published var selectedAlbum: Album?
    @Published var selectedArtist: String = ""
    
    var favoriteSongs: [Song] {
        songs.filter { song in
            UserDefaults.standard.bool(forKey: "song_\(song.id)_liked")
        }
    }
    
    private let deezerAPI = DeezerAPI()
    
    func fetchCategories() {
        deezerAPI.fetchCategories { [weak self] result in
            if let categories = result {
                DispatchQueue.main.async {
                    self?.categories = categories
                }
            }
        }
    }
    
    func fetchArtists(for category: Category) {
        deezerAPI.fetchArtists(for: category) { [weak self] result in
            if let artists = result {
                DispatchQueue.main.async {
                    self?.artists = artists
                }
            }
        }
    }
    
    func fetchAlbums(for artist: Artist) {
        deezerAPI.fetchAlbums(for: artist.id) { [weak self] result in
            if let albums = result {
                DispatchQueue.main.async {
                    self?.albums = albums
                }
            }
        }
    }
    
    func fetchSongs(for album: Album) {
        deezerAPI.fetchSongs(for: album.id) { [weak self] result in
            if let songs = result {
                DispatchQueue.main.async {
                    self?.songs = songs
                    self?.selectedAlbum = album // Set the selectedAlbum property
                }
            }
        }
    }
    
}
