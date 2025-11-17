import Foundation

// MARK: - Logica di Raccomandazione
class Recommender {
    
    private let allAvailableSongs: [Song] = allSongsData
    
   
    
    func generateDailyMix(from likedSongs: [Song], maxCount: Int = 10) -> [Song] {
        if likedSongs.isEmpty {
            // if not populated gives standard values
            return allAvailableSongs.filter { ["Pop", "Hip Hop"].contains($0.genre) }.shuffled().prefix(maxCount).map { $0 }
        }
        
        
        var genreCounts: [String: Int] = [:]
        for song in likedSongs {
            genreCounts[song.genre, default: 0] += 1
        }
        
        let totalLikedCount = likedSongs.count
        
        // Calculate songs in dailymix based on likes
        var targetMixComposition: [String: Int] = [:]
        for (genre, count) in genreCounts {
            let percentage = Double(count) / Double(totalLikedCount)
            // Arrotonda per avere numeri interi di brani da includere
            let targetCount = Int((percentage * Double(maxCount)).rounded())
            targetMixComposition[genre] = max(1, targetCount) // Assicura almeno 1 se il genere è piaciuto
        }
        
        // Populates mix
        var finalMix: [Song] = []
        var remainingSongs: [Song] = allAvailableSongs.shuffled() // Mescola la libreria per la casualità
        let likedIDs = Set(likedSongs.map { $0.id })
        
        for (genre, targetCount) in targetMixComposition {
            var addedCount = 0
            
            // filter for not liked songs
            let nonLikedSongsInGenre = remainingSongs.filter { $0.genre == genre && !likedIDs.contains($0.id) }
            
            for song in nonLikedSongsInGenre.prefix(targetCount) where addedCount < targetCount {
                finalMix.append(song)
                addedCount += 1
            }
            
            // liked songs for daily mix
            if addedCount < targetCount {
                let likedSongsInGenre = remainingSongs.filter { $0.genre == genre && likedIDs.contains($0.id) }
                for song in likedSongsInGenre.prefix(targetCount - addedCount) {
                    finalMix.append(song)
                }
            }
        }
        
        // mix songs
        return finalMix.shuffled().prefix(maxCount).map { $0 }
    }

    
    // function for generating mix
    func generateGenreMix(for genre: String, maxCount: Int = 8) -> [Song] {
        return allAvailableSongs
            .filter { $0.genre == genre || $0.genre.contains(genre) }
            .shuffled()
            .prefix(maxCount)
            .map { $0 }
    }
    
    // list for not liked songs(suggested)
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
