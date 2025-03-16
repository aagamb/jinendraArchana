// Goals
// Implement Auto-scroll , which stops when the phone is kept horizontally
// Implement Feedback, for beta testers
// Night mode
//  FAB button should work

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
