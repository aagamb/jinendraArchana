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
    @State private var collapsedSections: Set<String> = []
    
    var body: some View {
        
        NavigationStack {
            Group {
                if favoriteBooks.isEmpty {
                    emptyFavoritesView()
                } else {
                    favoritesListView()
                        .searchable(text: $searchText, prompt: "Title Name")
                }
            }
        }
        .onAppear(){
            loadFavorites()
        }
        .onDisappear(){
            saveFavorites()
        }
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
                            Section(header: sectionHeader(for: section)) {
                                if !collapsedSections.contains(section) {
                                    ForEach(filtered, id: \.id) { book in
                                        NavigationLink(destination: PDFViewerScreen(pdfName: book.name, isTabViewHidden: $isTabViewHidden)) {
                                            // each row in the view showing each book
                                            HStack {
                                                Text(book.hindiName)
                                                Spacer()
                                                Text(book.author)
                                                    .italic()
                                                    .foregroundStyle(.gray)
                                                    .frame(width: 100, alignment: .leading)
                                                    .lineLimit(2)
                                                Text("\(book.pgNum)")
                                                    .frame(width:40, height: 10, alignment: .trailing)
                                                    .padding(.trailing, 0)
                                            }
                                        }
                                    }
                                    .onDelete { indexSet in
                                        deleteBook(from: section, at: indexSet)
                                    }
                                    .onMove { source, destination in
                                        moveBook(in: section, from: source, to: destination)
                                    }
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                    }
                }
            }
            .animation(.default, value: collapsedSections)
            .navigationTitle("Favorites")
            .toolbar {
                EditButton() // enables reordering
            }

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
    
    // To handle section movements
    private func sectionHeader(for section: String) -> some View {
        HStack {
            Text(section.capitalized)
                .font(.headline)
            Spacer()
            Image(systemName: collapsedSections.contains(section) ? "chevron.down" : "chevron.up")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleSectionCollapse(section)
        }
    }
    
    /// Toggle collapsed State of a Section
    private func toggleSectionCollapse(_ section: String) {
        withAnimation {
            if collapsedSections.contains(section) {
                collapsedSections.remove(section)
            } else {
                collapsedSections.insert(section)
            }
        }
    }
    
    /// Move books within a section
    private func moveBook(in section: String, from source: IndexSet, to destination: Int) {
        if var books = favoriteBooks[section] {
            books.move(fromOffsets: source, toOffset: destination)
            favoriteBooks[section] = books
        }
    }
    
    /// delete books from the favorite Books section
    private func deleteBook(from section: String, at offsets: IndexSet) {
        if let books = favoriteBooks[section] {
            var updatedBooks = books
            updatedBooks.remove(atOffsets: offsets)
            favoriteBooks[section] = updatedBooks.isEmpty ? nil : updatedBooks
        }
    }
}




#Preview {
    FavoritesView(isTabViewHidden: .constant(false))
}




