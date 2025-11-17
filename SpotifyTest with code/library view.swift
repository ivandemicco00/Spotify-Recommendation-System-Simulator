//
//  library view.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//

import SwiftUI


struct LibraryView: View {
    @ObservedObject var library: MusicLibrary
    @State private var showingPlayer = false
    
    private var sortedSongs: [Song] {
        library.allSongs.sorted { $0.title < $1.title }
    }
    
    var body: some View {
        NavigationView {
            List {
        //liked
                NavigationLink {
                    LikedSongsView(library: library)
                } label: {
                    LikedSongsRow(count: library.likedSongs.count)
                }
                .listRowBackground(Color.black)

        
                Section {
                    ForEach(sortedSongs) { song in
                        SongRow(
                            song: song,
                            isPlaying: song.id == library.currentlyPlayingSong?.id,
                            library: library
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            library.setPlayingSong(song)
                            showingPlayer = true
                        }
                    }
                } header: {
                    Text("All Songs")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color.black)

            }
            .listStyle(PlainListStyle())
            .navigationTitle("Your Library")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .background(Color.black)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showingPlayer) {
            PlayerView(
                song: library.currentlyPlayingSong ?? (sortedSongs.first ?? library.allSongs.first!),
                library: library
            )
        }
    }
}

private struct LikedSongsRow: View {
    let count: Int

    var body: some View {
        HStack {
            Image(systemName: "heart.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.purple)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text("Liked Songs")
                    .foregroundColor(.white)
                Text("Playlist • \(count) songs")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
