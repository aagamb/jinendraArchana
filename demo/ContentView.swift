// Goals
// Finish the favorites menu
// Add a search functionality when hiding the big dictionary
// make the sections collapsible

import SwiftUI
import PDFKit

struct ContentView: View {
    
    @State private var isTabViewHidden = false
            
    var body: some View {
        
        NavigationView {
            
            TabView {
                BookListView(isTabViewHidden: $isTabViewHidden)
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Path")
                    }

                FavoritesView(isTabViewHidden: $isTabViewHidden)
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
            }
                
        }
        
    }
}

#Preview {
    ContentView()
}
