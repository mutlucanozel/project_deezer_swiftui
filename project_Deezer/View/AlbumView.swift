//  AlbumView.swift
//  Deneme
//
//  Created by Mutlu Can on 10.05.2023.
//

import UIKit
import SwiftUI

struct AlbumListView: View {
    let artist: Artist
    @EnvironmentObject private var viewModel: MainViewModel
    
    var body: some View {
        List(viewModel.albums) { album in
            NavigationLink(
                destination: SongListView(album: album)
                    .environmentObject(viewModel)
            
            ) {
                URLImage(urlString: album.cover)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(album.title)
                        .font(Font.custom("MyCustomFont", size: 21))
                    
                    Text(album.formattedReleaseDate)
                        .font(Font.custom("MyCustomFont", size: 14))
                        .padding(.top, 4)
                }
            }.listRowBackground(Color.clear)
        }
        .navigationTitle("\(artist.name)'s Albums")
        .onAppear {
            viewModel.fetchAlbums(for: artist)
        }
    }
}

