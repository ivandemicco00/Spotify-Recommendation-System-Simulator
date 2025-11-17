import SwiftUI



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
                    Text("Hello Ivan!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding([.horizontal, .top])
                    
                    SectionTitle(title: "🎶 Your Daily Mix")
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
                    
    
                    SectionTitle(title: "Made for Ivan")
                        .padding(.horizontal)
                    
                    NavigationLink(destination: LikedSongsView(library: library)) {
                        VStack(alignment: .leading) {
                            Text("Liked songs")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("\(library.likedSongs.count) songs")
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

            
                    SectionTitle(title: "Daily Mix based on genre")
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            GenreMixCard(genre: "Pop", library: library, recommender: recommender)
                            GenreMixCard(genre: "Hip Hop", library: library, recommender: recommender)
                            GenreMixCard(genre: "Rock", library: library, recommender: recommender)
             
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    

                    SectionTitle(title: "Discover new")
                        .padding(.horizontal)
                    
                    let suggestedArtists = recommender.generateArtistSuggestions(from: library.likedSongs, maxCount: 6)
                    
     
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



struct ArtistSuggestionCard: View {
    let song: Song
    @ObservedObject var library: MusicLibrary
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(song.coverArt)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(75)
                .clipped()
            
            Text(song.artist)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("Artist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
    }
}
