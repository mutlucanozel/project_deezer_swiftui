import SwiftUI
import AVKit

public struct SongView: View {
    let song: Song
    @State private var isPlaying: Bool = true
    @State private var currentAudioPlayer: AVPlayer?
    @State private var currentTime: Double = 0
    @State private var totalDuration: Double = 0
    @State private var isSeeking: Bool = false
    @State private var isLiked: Bool = false
    @State private var isAnimating: Bool = false
    
      public var body: some View {
          HStack(spacing: 16) {
              if let imageURL = song.imageURL {
                  AsyncImage(url: imageURL) { phase in
                      switch phase {
                      case .empty:
                          ProgressView()
                              .frame(width: 100, height: 100)
                              .cornerRadius(0)
                      case .success(let image):
                          image
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 100, height: 100)
                              .cornerRadius(10)
                      case .failure:
                          generateImageFromMD5(md5: song.md5_image)
                                                            .aspectRatio(contentMode: .fill)
                              .frame(width: 100, height: 100)
                              .cornerRadius(10)
                      @unknown default:
                          EmptyView()
                      }
                  }
                  .padding(8)
                  .background(Color.purple.opacity(0.2))
                  .cornerRadius(8)
              } else {
                  generateImageFromMD5(md5: song.md5_image)
               
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 80, height: 80)
                      .padding(3)
                      .background(Color.blue)
                      .cornerRadius(10)
              }
              
              VStack(alignment: .leading, spacing: 8) {
                  Text(song.title)
                      .font(.headline)
                      .foregroundColor(Color.blue)
                  Text("Duration: \(formattedDuration(currentTime: currentTime, totalDuration: totalDuration))")
                      .font(.subheadline)
                      .foregroundColor(.secondary)
                  
                  HStack(spacing: 16) {
                      Slider(value: $currentTime, in: 0...(totalDuration.isFinite ? totalDuration : 0),
                             onEditingChanged: { editing in
                                 isSeeking = editing
                                 if isSeeking {
                                     currentAudioPlayer?.pause()
                                 } else {
                                     currentAudioPlayer?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000))
                                     currentAudioPlayer?.play()
                                 }
                             })
                          .frame(maxWidth: .infinity)
                          .accentColor(Color.blue)
                          .foregroundColor(Color.blue)
                      
                    Button(action: {
                        isPlaying.toggle()
                        togglePlayback()
                    }) {
                        Image(systemName: isPlaying ? "play.circle.fill" : "pause.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0.3568627451, blue: 0.7725490196, alpha: 1))) // #005bc5
                    Button(action: {
                        withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(1)) {
                                                    isLiked.toggle()
                                           }
                                           UserDefaults.standard.set(isLiked, forKey: "song_\(song.id)_liked")
                                       }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }.buttonStyle(PlainButtonStyle())
                        .foregroundColor(isLiked ? Color(#colorLiteral(red: 0, green: 0.3568627451, blue: 0.7725490196, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0.3568627451, blue: 0.7725490196, alpha: 1)))
                        .rotationEffect(isLiked ? .degrees(360) : .degrees(0))
                                                }
            }
            .padding()
            .cornerRadius(8)
        }.listRowBackground(Color.clear)
        .padding(.horizontal, 16)
        .cornerRadius(18)
     
        .onAppear {
            if let previewURL = URL(string: song.previewURL) {
                let newAudioPlayer = AVPlayer(url: previewURL)
                currentAudioPlayer = newAudioPlayer
                // Observe player time changes
                currentAudioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: .main) { time in
                    guard let duration = currentAudioPlayer?.currentItem?.duration.seconds else { return }
                    currentTime = time.seconds
                    totalDuration = duration
                }
            }
            isLiked = UserDefaults.standard.bool(forKey: "song_\(song.id)_liked")
        }
        .onDisappear {
            currentAudioPlayer?.pause()
            currentAudioPlayer = nil
        }
    }
    
    
    private func togglePlayback() {
        if isPlaying {
            currentAudioPlayer?.pause()
        } else {
            currentAudioPlayer?.play()
        }
    }
    
    private func formattedDuration(currentTime: Double, totalDuration: Double) -> String {
        guard currentTime.isFinite, totalDuration.isFinite else {
            return "--:-- / --:--"
        }
        
        let currentMinutes = Int(currentTime) / 60
        let currentSeconds = Int(currentTime) % 60
        
        let totalMinutes = Int(totalDuration) / 60
        let totalSeconds = Int(totalDuration) % 60
        
        return String(format: "%d:%02d / %d:%02d", currentMinutes, currentSeconds, totalMinutes, totalSeconds)
    }
}
public struct SongListView: View {
    let album: Album
    @EnvironmentObject private var viewModel: MainViewModel

    public var body: some View {
                    VStack { // Wrap the VStack around the List and the title


                List(viewModel.songs) { song in
                    SongView(song: song)
                }
            }
                    .navigationTitle(album.title)
                    .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            viewModel.fetchSongs(for: album)
        }
    }
}

private func generateImageFromMD5(md5: String) -> some View {
    let md5String = md5.lowercased()
    let imageURLString = "https://e-cdns-images.dzcdn.net/images/cover/\(md5String)/120x120-000000-80-0-0.jpg"

    guard let imageURL = URL(string: imageURLString) else {
        return AnyView(Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(10))
    }

    // Fetch the image from the URL and return it as an Image view
    // You can use your preferred method for fetching the image data

    // Example using URLSession:
    guard let imageData = try? Data(contentsOf: imageURL) else {
        return AnyView(Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(9))
    }

    guard let uiImage = UIImage(data: imageData) else {
        return AnyView(Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(9))
    }

    return AnyView(
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(9)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.blue, lineWidth: 2)
            )
    )
}
