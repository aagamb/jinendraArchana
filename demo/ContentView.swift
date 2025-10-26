// Goals

// FAB animation
// Add search on words, not just the first one
// for later - search view should split each title into words, and search on each word, and get minimum edit distance
// for later - an arghawali section
// for later - have sub-dropdowns - like for chahdhala - six dhaals should show
// for later - Implement Auto-scroll , which stops when the phone is kept horizontally

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
                        Text("Favorite")
                    }
                FeedbackView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Feedback")
                    }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
