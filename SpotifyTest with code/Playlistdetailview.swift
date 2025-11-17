import SwiftUI

// MARK: - 6. Playlist Detail View

struct PlaylistDetailView: View {
    let title: String
    let songs: [Song]
    @ObservedObject var library: MusicLibrary
    
    @State private var showingPlayer = false
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                Image(songs.first?.coverArt ?? "placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.top, 20)
                
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Text("\(songs.count) brani consigliati")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            
            //songs list
            ForEach(songs) { song in
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
        // full screen player
        .fullScreenCover(isPresented: $showingPlayer) {
            PlayerView(song: library.currentlyPlayingSong ?? library.allSongs[0],
                       library: library)
        }
    }
}
