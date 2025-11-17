import SwiftUI
import Combine

// MARK: - 1. ContentView (Tab Bar Principale)

import SwiftUI
import Combine

// MARK: - 1. ContentView (Tab Bar Principale Senza Mini Player)

struct ContentView: View {
    
    @StateObject var library = MusicLibrary()
    
    // Non abbiamo più bisogno del timer qui, la progressione è gestita solo in PlayerView Full Screen.
    let recommender = Recommender()
    
    var body: some View {
        TabView {
            // Tab Home
            HomeView(library: library, recommender: recommender)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            
            
            // Tab Library
            LibraryView(library: library)
                .tabItem {
                    Label("Libreria", systemImage: "books.vertical.fill")
                }
            
            // Tab Crea (Placeholder)
            Text("Crea Playlist")
                .tabItem {
                    Label("Crea", systemImage: "plus.circle.fill")
                }
        }
        // Impostazioni Tab Bar (stile Spotify)
        .accentColor(.white)
        .onAppear {
            UITabBar.appearance().backgroundColor = .black.withAlphaComponent(0.8)
            UITabBar.appearance().unselectedItemTintColor = .gray
        }
        // Necessario per assicurare lo sfondo scuro se una view modale viene chiusa
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
