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
    
    @AppStorage("useStreak") private var useStreak = false
    @State private var isTabViewHidden = false
    @State private var isSettingsOpen = false
    @State private var isSearchActive = false
    @State private var selectedTab: Int = 0
    @ObservedObject private var tracker = AppOpenTracker.shared
            
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                BookListView(isTabViewHidden: $isTabViewHidden, isSearchActive: $isSearchActive)
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Path")
                    }
                    .tag(0)

                FavoritesView(isTabViewHidden: $isTabViewHidden)
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                    .tag(1)

                if useStreak {
                    StreakView()
                        .tabItem {
                            Image(systemName: "flame.fill")
                            Text("Streak")
                        }
                        .tag(2)
                }
                // FeedbackView()
                //     .tabItem {
                //         Image(systemName: "person.2.fill")
                //         Text("Feedback")
                //     }
            }

            if isSettingsOpen {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            isSettingsOpen = false
                        }
                    }

                SettingsPanel(isOpen: $isSettingsOpen, useStreak: $useStreak)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .onAppear {
            tracker.markOpenedToday()
        }
        .overlay(alignment: .topLeading) {
            if selectedTab == 0 && !isSettingsOpen && !isSearchActive && !isTabViewHidden {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        isSettingsOpen = true
                    }
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle().fill(.ultraThinMaterial)
                        )
                        .overlay(
                            Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
                .padding(.leading, 12)
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    ContentView()
}
