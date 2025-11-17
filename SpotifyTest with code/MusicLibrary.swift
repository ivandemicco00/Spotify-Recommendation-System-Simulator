//
//  MusicLibrary.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//

import SwiftUI
import Foundation
import Combine


// MARK: - La Sorgente Unica della Verità
class MusicLibrary: ObservableObject {
    @Published var allSongs: [Song] = allSongsData.map {
        // ... (resto della logica di inizializzazione) ...
        var song = $0
        if ["Good 4 u", "Therefore I Am", "Levitating"].contains(song.title) {
            song.isFavorite = true
        }
        return song
    }
    
    @Published var currentlyPlayingSong: Song? = allSongsData.first(where: { $0.title == "Good 4 u" })
    @Published var isPlaying: Bool = true
    
    var likedSongs: [Song] {
        allSongs.filter { $0.isFavorite }
    }
    
    func toggleFavorite(song: Song) {
        if let index = allSongs.firstIndex(where: { $0.id == song.id }) {
            allSongs[index].isFavorite.toggle()
            if currentlyPlayingSong?.id == song.id {
                currentlyPlayingSong = allSongs[index]
            }
        }
    }
    
    func setPlayingSong(_ song: Song) {
        currentlyPlayingSong = song
        isPlaying = true
    }
    
    // MARK: - Nuove Funzioni di Navigazione
    
    // Trova il brano successivo nella libreria completa
    func playNextSong() {
        guard let currentSong = currentlyPlayingSong else { return }
        
        // Trova l'indice del brano corrente nella lista completa e ordinata
        let sortedSongs = allSongs.sorted { $0.title < $1.title }
        if let currentIndex = sortedSongs.firstIndex(where: { $0.id == currentSong.id }) {
            
            // Calcola l'indice successivo (fa il wrap intorno se arriviamo alla fine)
            let nextIndex = (currentIndex + 1) % sortedSongs.count
            currentlyPlayingSong = sortedSongs[nextIndex]
            isPlaying = true
        }
    }
    
    // Trova il brano precedente nella libreria completa
    func playPreviousSong() {
        guard let currentSong = currentlyPlayingSong else { return }
        
        // Trova l'indice del brano corrente nella lista completa e ordinata
        let sortedSongs = allSongs.sorted { $0.title < $1.title }
        if let currentIndex = sortedSongs.firstIndex(where: { $0.id == currentSong.id }) {
            
            // Calcola l'indice precedente (fa il wrap intorno se arriviamo all'inizio)
            let previousIndex = (currentIndex - 1 + sortedSongs.count) % sortedSongs.count
            currentlyPlayingSong = sortedSongs[previousIndex]
            isPlaying = true
        }
    }
}
