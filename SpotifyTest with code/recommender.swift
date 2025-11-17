import Foundation

// MARK: - Logica di Raccomandazione
class Recommender {
    
    private let allAvailableSongs: [Song] = allSongsData
    
    /**
     Genera un Daily Mix basato sulla distribuzione percentuale dei generi piaciuti.
     
     L'algoritmo:
     1. Calcola la distribuzione percentuale dei generi nei brani piaciuti (es. Rap: 80%, Pop: 20%).
     2. Determina quanti brani per ogni genere devono essere inclusi nel Daily Mix finale (es. 8 su 10 Rap, 2 su 10 Pop).
     3. Raccoglie i brani richiesti in modo casuale, dando priorità ai brani che non sono ancora piaciuti.
     */
    func generateDailyMix(from likedSongs: [Song], maxCount: Int = 10) -> [Song] {
        if likedSongs.isEmpty {
            // Se l'utente non ha preferiti, fornisce un mix di generi popolari iniziali
            return allAvailableSongs.filter { ["Pop", "Hip Hop"].contains($0.genre) }.shuffled().prefix(maxCount).map { $0 }
        }
        
        // --- 1. Calcola la Distribuzione Percentuale dei Generi ---
        var genreCounts: [String: Int] = [:]
        for song in likedSongs {
            genreCounts[song.genre, default: 0] += 1
        }
        
        let totalLikedCount = likedSongs.count
        
        // Calcola quante canzoni di ogni genere dovrebbero comporre il mix
        var targetMixComposition: [String: Int] = [:]
        for (genre, count) in genreCounts {
            let percentage = Double(count) / Double(totalLikedCount)
            // Arrotonda per avere numeri interi di brani da includere
            let targetCount = Int((percentage * Double(maxCount)).rounded())
            targetMixComposition[genre] = max(1, targetCount) // Assicura almeno 1 se il genere è piaciuto
        }
        
        // --- 2. Popola il Mix in base alla composizione target ---
        var finalMix: [Song] = []
        var remainingSongs: [Song] = allAvailableSongs.shuffled() // Mescola la libreria per la casualità
        let likedIDs = Set(likedSongs.map { $0.id })
        
        for (genre, targetCount) in targetMixComposition {
            var addedCount = 0
            
            // Priorità 1: Aggiungi brani *non* piaciuti in questo genere
            let nonLikedSongsInGenre = remainingSongs.filter { $0.genre == genre && !likedIDs.contains($0.id) }
            
            for song in nonLikedSongsInGenre.prefix(targetCount) where addedCount < targetCount {
                finalMix.append(song)
                addedCount += 1
            }
            
            // Priorità 2: Se mancano ancora brani, aggiungi brani *già piaciuti* (per assicurare la dimensione)
            if addedCount < targetCount {
                let likedSongsInGenre = remainingSongs.filter { $0.genre == genre && likedIDs.contains($0.id) }
                for song in likedSongsInGenre.prefix(targetCount - addedCount) {
                    finalMix.append(song)
                }
            }
        }
        
        // 3. Mescola il risultato finale (per non avere blocchi di generi) e limita la dimensione
        return finalMix.shuffled().prefix(maxCount).map { $0 }
    }
    
    // ... (generateGenreMix e generateArtistSuggestions restano invariate) ...
    
    // Funzione per generare mix basati specificamente sul genere
    func generateGenreMix(for genre: String, maxCount: Int = 8) -> [Song] {
        return allAvailableSongs
            .filter { $0.genre == genre || $0.genre.contains(genre) }
            .shuffled()
            .prefix(maxCount)
            .map { $0 }
    }
    
    // Genera una lista di artisti non ancora "preferiti" ma con generi simili
    func generateArtistSuggestions(from likedSongs: [Song], maxCount: Int = 8) -> [Song] {
        let favoriteGenres = Set(likedSongs.map { $0.genre })
        let favoriteArtists = Set(likedSongs.map { $0.artist })
        
        let suggestions = allAvailableSongs.filter { song in
            let isNewArtist = !favoriteArtists.contains(song.artist)
            let isSimilarGenre = favoriteGenres.contains(song.genre)
            
            return isNewArtist && isSimilarGenre
        }
        
        let uniqueArtistSuggestions = Set(suggestions.map { $0.artist }).compactMap { artist in
            suggestions.first(where: { $0.artist == artist })
        }
        
        return uniqueArtistSuggestions.shuffled().prefix(maxCount).map { $0 }
    }
}
