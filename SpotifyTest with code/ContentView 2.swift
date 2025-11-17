import SwiftUI
import Combine



import SwiftUI
import Combine



struct ContentView: View {
    
    @StateObject var library = MusicLibrary()
    

    let recommender = Recommender()
    //TABBAR
    var body: some View {
        TabView {
         
            HomeView(library: library, recommender: recommender)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            
            
            
            LibraryView(library: library)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
            
            // Tab Crea (Placeholder)
            Text("Create Playlist")
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
        }
        
        .accentColor(.white)
        .onAppear {
            UITabBar.appearance().backgroundColor = .black.withAlphaComponent(0.8)
            UITabBar.appearance().unselectedItemTintColor = .gray
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
