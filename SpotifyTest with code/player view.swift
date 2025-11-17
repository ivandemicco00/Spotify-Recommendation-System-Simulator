//
//  player view.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 15/11/25.
//



import SwiftUI
import Combine

// MARK: - 5. Player View (Full Screen)

struct PlayerView: View {
    let song: Song // Il brano corrente visualizzato, passato al modale
    @ObservedObject var library: MusicLibrary // La libreria per i controlli
    
    @Environment(\.dismiss) var dismiss
    
    @State private var playbackProgress: Double = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            // ... (Intestazione e Immagine/Dettagli invariati) ...
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down").font(.title2).foregroundColor(.white)
                }
                Spacer()
                Text(song.artist.uppercased()).font(.caption).fontWeight(.bold).foregroundColor(.white)
                Spacer()
                Image(systemName: "ellipsis").font(.title2).foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            Image(song.coverArt)
                .resizable()
                .scaledToFit()
                .frame(width: 320, height: 320)
                .cornerRadius(10)
                .shadow(radius: 15)
                .padding(.bottom, 30)
            
            VStack {
                Text(song.title).font(.largeTitle).fontWeight(.heavy).foregroundColor(.white).multilineTextAlignment(.center)
                Text(song.artist).font(.title2).foregroundColor(.gray)
                Text("Genere: \(song.genre)").font(.headline).foregroundColor(.teal).padding(.top, 5)
            }
            .padding(.horizontal)
            
            // Barra di progressione estesa
            VStack(spacing: 5) {
                ProgressView(value: playbackProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .padding(.horizontal)
                
                HStack {
                    Text("0:00").font(.caption).foregroundColor(.gray)
                    Spacer()
                    Text("3:30").font(.caption).foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Controlli di Riproduzione
                HStack {
                    Button {
                        library.toggleFavorite(song: song)
                    } label: {
                        Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(song.isFavorite ? .green : .white)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    // BRANO PRECEDENTE (CLICCABILE)
                    Button {
                        library.playPreviousSong()
                    } label: {
                        Image(systemName: "backward.fill").font(.title2).foregroundColor(.white)
                    }
                    
                    Button {
                        library.isPlaying.toggle()
                    } label: {
                        Image(systemName: library.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 20)
                    
                    // BRANO SUCCESSIVO (CLICCABILE)
                    Button {
                        library.playNextSong()
                    } label: {
                        Image(systemName: "forward.fill").font(.title2).foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "shuffle").font(.title2).foregroundColor(.white)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            .padding(.top, 40)
            
            Spacer()
        }
        .onAppear {
            playbackProgress = 0.0
        }
        .onReceive(timer) { _ in
            if library.isPlaying {
                playbackProgress += 0.005
                if playbackProgress >= 1.0 {
                    // Quando finisce, passa automaticamente al brano successivo
                    library.playNextSong()
                    playbackProgress = 0.0
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
