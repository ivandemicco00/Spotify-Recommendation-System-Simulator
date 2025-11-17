//
//  song.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//

import Foundation

// MARK: - Modello Dati
struct Song: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let genre: String
    let coverArt: String
    var isFavorite: Bool = false

    func toggleFavorite() -> Song {
        var newSong = self
        newSong.isFavorite.toggle()
        return newSong
    }
}

// MARK: - Libreria Estesa di Canzoni (All Songs)

let allSongsData: [Song] = [
    // --- Pop / Pop-Punk (Genere 1) ---
    Song(title: "Good 4 u", artist: "Olivia Rodrigo", genre: "Pop-Punk", coverArt: "olivia_rodrigo_good4u"),
    Song(title: "Traitor", artist: "Olivia Rodrigo", genre: "Pop-Punk", coverArt: "olivia_rodrigo_traitor"),
    Song(title: "Therefore I Am", artist: "Billie Eilish", genre: "Pop", coverArt: "billie_eilish_thereforeiam"),
    Song(title: "Happier Than Ever", artist: "Billie Eilish", genre: "Pop", coverArt: "billie_eilish_happierthanever"),
    Song(title: "Levitating", artist: "Dua Lipa", genre: "Pop", coverArt: "dua_lipa_levitating"),
    Song(title: "Future Nostalgia", artist: "Dua Lipa", genre: "Pop", coverArt: "dua_lipa_futurenostalgia"),
    Song(title: "Misery Business", artist: "Paramore", genre: "Pop-Punk", coverArt: "paramore_miserybusiness"),
    Song(title: "Blinding Lights", artist: "The Weeknd", genre: "Pop", coverArt: "theweeknd_blindinglights"),
    Song(title: "Save Your Tears", artist: "The Weeknd", genre: "Pop", coverArt: "theweeknd_saveyourtears"),
    Song(title: "Don't Start Now", artist: "Dua Lipa", genre: "Pop", coverArt: "dua_lipa_dontstartnow"),
    
    // --- Hip Hop / Rap (Genere 2) ---
    Song(title: "HUMBLE.", artist: "Kendrick Lamar", genre: "Hip Hop", coverArt: "kendrick_humble"),
    Song(title: "Money Trees", artist: "Kendrick Lamar", genre: "Hip Hop", coverArt: "kendrick_moneytrees"),
    Song(title: "God's Plan", artist: "Drake", genre: "Hip Hop", coverArt: "drake_godsplan"),
    Song(title: "Hotline Bling", artist: "Drake", genre: "Hip Hop", coverArt: "drake_hotlinebling"),
    Song(title: "SICKO MODE", artist: "Travis Scott", genre: "Trap", coverArt: "travis_sickomode"),
    Song(title: "Lose Yourself", artist: "Eminem", genre: "Rap", coverArt: "eminem_loseyourself"),
    Song(title: "The Box", artist: "Roddy Ricch", genre: "Trap", coverArt: "roddy_thebox"),
    Song(title: "Rich Flex", artist: "Drake", genre: "Trap", coverArt: "drake_richflex"),
    Song(title: "Forgot About Dre", artist: "Dr. Dre", genre: "Rap", coverArt: "drdre_forgotaboutdre"),

    // --- Rock / Alternative (Genere 3) ---
    Song(title: "Mr. Brightside", artist: "The Killers", genre: "Alternative Rock", coverArt: "thekillers_mrbrightside"),
    Song(title: "Bohemian Rhapsody", artist: "Queen", genre: "Classic Rock", coverArt: "queen_bohemianrhapsody"),
    Song(title: "Smells Like Teen Spirit", artist: "Nirvana", genre: "Grunge", coverArt: "nirvana_smellslike"),
    Song(title: "Numb", artist: "Linkin Park", genre: "Nu Metal", coverArt: "linkinpark_numb"),
    Song(title: "Seven Nation Army", artist: "The White Stripes", genre: "Garage Rock", coverArt: "whitestripes_sevennationarmy"),
    Song(title: "Come As You Are", artist: "Nirvana", genre: "Grunge", coverArt: "nirvana_comeasyouare"),
    Song(title: "Stairway to Heaven", artist: "Led Zeppelin", genre: "Classic Rock", coverArt: "ledzeppelin_stairwaytoheaven"),

    // --- Altro (Funk / Soul) ---
    Song(title: "September", artist: "Earth, Wind & Fire", genre: "Funk", coverArt: "earthwindfire_september"),
    Song(title: "Hello", artist: "Adele", genre: "Soul", coverArt: "adele_hello"),
    Song(title: "Rolling in the Deep", artist: "Adele", genre: "Soul", coverArt: "adele_rollinginthedeep"),
]
