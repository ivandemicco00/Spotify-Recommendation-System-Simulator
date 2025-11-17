import SwiftUI

// MARK: - 2. Home View (Daily Mix e Made for Ivan)

struct HomeView: View {
    @ObservedObject var library: MusicLibrary
    let recommender: Recommender
    
    var dailyMix: [Song] {
        recommender.generateDailyMix(from: library.likedSongs)
    }
    
    @State private var showingPlayer = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Ciao Ivan!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding([.horizontal, .top])
                    
                    // --- 1. Daily Mix Verticale (La tua playlist principale) ---
                    SectionTitle(title: "🎶 Il tuo Daily Mix")
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    
                    ForEach(dailyMix.prefix(5)) { song in
                        SongRow(song: song,
                                isPlaying: song.id == library.currentlyPlayingSong?.id,
                                library: library)
                            .onTapGesture {
                                library.setPlayingSong(song)
                                showingPlayer = true
                            }
                            .padding(.horizontal)
                    }
                    
                    Divider().padding(.vertical, 10).background(Color.clear)
                    
                    // --- 2. Sezione Made For Ivan (Brani Piaciuti) ---
                    SectionTitle(title: "Made for Ivan")
                        .padding(.horizontal)
                    
                    NavigationLink(destination: LikedSongsView(library: library)) {
                        VStack(alignment: .leading) {
                            Text("Brani Piaciuti")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("\(library.likedSongs.count) canzoni")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.purple.opacity(0.8))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 30)

                    // --- 3. HSTACK SCROLLABILE: Daily Mix per Genere ---
                    SectionTitle(title: "Daily Mix Basati sui tuoi generi")
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            GenreMixCard(genre: "Pop", library: library, recommender: recommender)
                            GenreMixCard(genre: "Hip Hop", library: library, recommender: recommender)
                            GenreMixCard(genre: "Rock", library: library, recommender: recommender)
                            // Aggiungi altri generi se necessario
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    
                    // --- 4. Sezione Artisti che ti potrebbero piacere ---
                    SectionTitle(title: "Scopri nuovi Artisti")
                        .padding(.horizontal)
                    
                    let suggestedArtists = recommender.generateArtistSuggestions(from: library.likedSongs, maxCount: 6)
                    
                    // Utilizziamo un Grid per mostrare le schede degli artisti
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(suggestedArtists) { song in
                            ArtistSuggestionCard(song: song, library: library)
                                .onTapGesture {
                                    library.setPlayingSong(song)
                                    showingPlayer = true
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showingPlayer) {
            PlayerView(song: library.currentlyPlayingSong ?? library.allSongs[0],
                       library: library)
        }
    }
}

// MARK: - Componente per la card del Mix di Genere (HStack Scrollabile)

struct GenreMixCard: View {
    let genre: String
    @ObservedObject var library: MusicLibrary
    let recommender: Recommender
    
    @State private var showingPlayer = false
    
    var body: some View {
        let mix = recommender.generateGenreMix(for: genre)
        
        VStack(alignment: .leading) {
            // Usa la prima copertina come rappresentante
            Image(mix.first?.coverArt ?? "placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .clipped()
            
            Text("Daily Mix")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(genre)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 150)
        .onTapGesture {
            // Quando si clicca sul Mix, riproduce il primo brano della playlist
            if let firstSong = mix.first {
                library.setPlayingSong(firstSong)
                showingPlayer = true
            }
        }
        .fullScreenCover(isPresented: $showingPlayer) {
            PlayerView(song: library.currentlyPlayingSong ?? library.allSongs[0],library: library)
        }
    }
}

// MARK: - Componente per la card del Suggerimento Artista

struct ArtistSuggestionCard: View {
    let song: Song
    @ObservedObject var library: MusicLibrary
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(song.coverArt)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(75) // Forma circolare per l'artista
                .clipped()
            
            Text(song.artist)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("Artista")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
    }
}
