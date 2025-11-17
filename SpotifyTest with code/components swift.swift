//
//  components swift.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//
import SwiftUI

// MARK: - Componenti UI Condivisi

struct SectionTitle: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 10)
    }
}

// Row del Brano con Pulsante Mi Piace
struct SongRow: View {
    let song: Song
    let isPlaying: Bool
    @ObservedObject var library: MusicLibrary
    
    var body: some View {
        HStack {
            Image(song.coverArt)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                    .foregroundColor(isPlaying ? .green : .white)
                Text("\(song.artist) • \(song.genre)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            // Pulsante Mi Piace/Cuore: Aggiorna lo stato, ma il brano resta visibile
            Button {
                library.toggleFavorite(song: song)
            } label: {
                // Controlla lo stato attuale del brano nella libreria
                let isCurrentFavorite = library.allSongs.first(where: { $0.id == song.id })?.isFavorite ?? false
                
                Image(systemName: isCurrentFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isCurrentFavorite ? .green : .gray)
                    .padding(.leading)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 5)
        .listRowBackground(Color.black)
    }
}
