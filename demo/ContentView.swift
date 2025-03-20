// Goals
// Implement Auto-scroll , which stops when the phone is kept horizontally
// FAB animation
// search view should split each title into words, and search on each word, and get minimum edit distance
// for later - an arghawali section
// run a cron-job to keep server active
// have sub-dropdowns - like for chahdhala - six dhaals should show

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
