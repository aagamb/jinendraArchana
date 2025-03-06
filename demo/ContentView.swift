// Goals
// Finish the favorites menu
// Set autozoom to 1.2x times the default zoom level when turning from portrait to landscape
// Add a search functionality when hiding the big dictionary
// make the sections collapsible
// zoom to the pdf should be limited to certain ranges

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
