//
//  MusicLibrary.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//

import SwiftUI
import Foundation
import Combine


class MusicLibrary: ObservableObject {
    @Published var allSongs: [Song] = allSongsData.map {
        
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
    
    
    
    
    func playNextSong() {
        guard let currentSong = currentlyPlayingSong else { return }
        
       
        let sortedSongs = allSongs.sorted { $0.title < $1.title }
        if let currentIndex = sortedSongs.firstIndex(where: { $0.id == currentSong.id }) {
            
  
            let nextIndex = (currentIndex + 1) % sortedSongs.count
            currentlyPlayingSong = sortedSongs[nextIndex]
            isPlaying = true
        }
    }
    

    func playPreviousSong() {
        guard let currentSong = currentlyPlayingSong else { return }
        

        let sortedSongs = allSongs.sorted { $0.title < $1.title }
        if let currentIndex = sortedSongs.firstIndex(where: { $0.id == currentSong.id }) {
            
           
            let previousIndex = (currentIndex - 1 + sortedSongs.count) % sortedSongs.count
            currentlyPlayingSong = sortedSongs[previousIndex]
            isPlaying = true
        }
    }
}
