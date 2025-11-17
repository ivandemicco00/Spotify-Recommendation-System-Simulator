//
//  liked songs view.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//

import SwiftUI



struct LikedSongsView: View {
    @ObservedObject var library: MusicLibrary
    @State private var showingPlayer = false
    @State private var playbackProgress: Double = 0.7
    
    var body: some View {
        List {
            ForEach(library.likedSongs) { song in
                SongRow(song: song,
                        isPlaying: song.id == library.currentlyPlayingSong?.id,
                        library: library)
                    .onTapGesture {
                        library.setPlayingSong(song)
                        showingPlayer = true
                    }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Liked Songs")
        .preferredColorScheme(.dark)
        .background(Color.black)
        .fullScreenCover(isPresented: $showingPlayer) {
            PlayerView(
                song: library.currentlyPlayingSong ?? library.allSongs[0],
               
                library: library
            )
        }
    }
}
