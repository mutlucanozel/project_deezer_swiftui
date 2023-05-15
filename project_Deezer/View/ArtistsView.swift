import SwiftUI

struct ArtistListView: View {
    let category: Category
    @EnvironmentObject private var viewModel: MainViewModel
    
    var body: some View {
        List(viewModel.artists) { artist in
            NavigationLink(
                destination: AlbumListView(artist: artist)
                    .environmentObject(viewModel)
            ) {
                VStack {
                    HStack(alignment: .center) {
                        URLImage(urlString: artist.picture)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .cornerRadius(10)
                        
                        
                        // Sanatçı adı
                        Text(artist.name)
                    }
                }
                
            }.listRowBackground(Color.clear)
        }
        .navigationTitle("\(category.name) Artists")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchArtists(for: category)
        }
    }
}
struct URLImage: View {
    @ObservedObject private var imageLoader: ImageLoader
    private let placeholderImage: Image
    
    init(urlString: String, placeholderImage: Image = Image(systemName: "photo")) {
        self.imageLoader = ImageLoader(urlString: urlString)
        self.placeholderImage = placeholderImage
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholderImage
                .resizable()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let cachedImage = ImageCache.shared.image(for: urlString) {
            // Use cached image if available
            image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                ImageCache.shared.set(image: image, urlString: self?.urlString)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
    class ImageCache {
        static let shared = ImageCache()
        
        private let cache = NSCache<NSString, UIImage>()
        
        private init() {}
        
        func image(for urlString: String?) -> UIImage? {
            guard let urlString = urlString else {
                return nil
            }
            
            return cache.object(forKey: urlString as NSString)
        }
        
        func set(image: UIImage, urlString: String?) {
            guard let urlString = urlString else {
                return
            }
            
            cache.setObject(image, forKey: urlString as NSString)
        }
    }
}

