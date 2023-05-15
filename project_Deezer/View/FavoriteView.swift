import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    if viewModel.songs.filter({ song in
                        UserDefaults.standard.bool(forKey: "song_\(song.id)_liked")
                    }).isEmpty {
                        Text("There are no favorite songs.")
                            .font(.title)
                            .foregroundColor(.blue)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        List {
                            ForEach(viewModel.songs.filter { song in
                                UserDefaults.standard.bool(forKey: "song_\(song.id)_liked")
                            }) { song in
                                SongView(song: song)
                                    .contextMenu {
                                        Button(action: {
                                            UserDefaults.standard.set(false, forKey: "song_\(song.id)_liked")
                                            viewModel.objectWillChange.send()
                                        }) {
                                            Label("Unlike", systemImage: "heart.slash.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.white)
                    }
                }
            }
            .navigationBarTitle("Favorited Songs", displayMode: .inline)
        }
    }
}
