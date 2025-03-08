//
//  favoriteSectionView.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    
    @Binding var isTabViewHidden: Bool
    @State private var isSelectingFavorites = false
    @State private var favoriteBooks: [String: [Book]] = [:]
    @State private var searchText: String = ""
    
    var body: some View {
        
        NavigationStack {
            if favoriteBooks.isEmpty {
                emptyFavoritesView()
            } else {
                favoritesListView()
            }
        }
        .onAppear(){
            loadFavorites()
        }
        .onDisappear(){
            saveFavorites()
        }
        .searchable(text: $searchText, prompt: "Title Name")
        .autocorrectionDisabled(true)
        .sheet(isPresented: $isSelectingFavorites) {
            FavoritesSelectionView(favoriteBooks: $favoriteBooks, isSelectingFavorites: $isSelectingFavorites, isTabViewHidden: $isTabViewHidden, searchText: "")
        }
    }
    
    /// Displays empty favorites view
    private func emptyFavoritesView() -> some View {
        VStack {
            Image(systemName: "star.slash")
                .font(.system(size: 100))
            
            Text("No favorites added")
                .padding(10)
            
            Button(action: {
                isSelectingFavorites = true
            }) {
                Text("Add Favorites")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding()
            }
        }
        .navigationTitle("Favorites")
    }
    
    /// Displays the list of favorite books
    private func favoritesListView() -> some View {
        let keyOrder = ["Stavan", "Poojan", "Adhyatmik Path", "Bhakti"]
        return ZStack {
            List {
                ForEach(keyOrder, id: \.self) { section in
                    if let books = favoriteBooks[section] {
                        let filtered = filteredBooks(from: books, searchText: searchText)
                        if !filtered.isEmpty {
                            Section(header: Text(section.capitalized)) {
                                sectionList(for: section, books: filtered, isTabViewHidden: $isTabViewHidden)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")

            floatingAddButton()
        }
    }
    
    /// Floating button to add favorites
    private func floatingAddButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isSelectingFavorites = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .padding()
                        .frame(maxWidth: 100, maxHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.trailing, 0)
                .padding(.bottom, 16)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    /// Saves 'favoriteBooks' persistently using 'UserDefaults'
    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favoriteBooks)
            UserDefaults.standard.set(data, forKey: "favoriteBooks")
        } catch {
            print("Error from func 'saveFavorites()' from 'favoritesView'. Failed to save favorite books: ", error)
        }
    }
    
    /// Loads 'favoriteBooks' from 'UserDefaults'
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteBooks") {
            do {
                favoriteBooks = try JSONDecoder().decode([String: [Book]].self, from: data)
            } catch {
                print("Error from func 'loadFavorites()' from 'favoritesView'. Failed to load favorite books: ", error)
            }
        }
    }
    
}




#Preview {
    FavoritesView(isTabViewHidden: .constant(false))
}
