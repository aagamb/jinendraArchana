//
//  FavoritesSelectionView.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI

struct FavoritesSelectionView: View {
    @Binding var favoriteBooks: [String: [Book]]
    @Binding var isSelectingFavorites: Bool
    @Binding var isTabViewHidden: Bool
    
    @State var searchText: String
    @State private var selectedBooks : [String: Set<Book>] = [:]
    
    private let keyOrder = ["Poojan", "Stavan", "Adhyatmik Path", "Bhakti"]
    
    var body: some View{
        NavigationStack{
            List {
                ForEach(keyOrder, id: \.self) { section in
                    if let books = sections[section] {
                        let filtered = filteredBooks(from: books, searchText: searchText) // Function from BookListView

                        if !filtered.isEmpty {
                            Section(header: Text(section.capitalized)) {
                                ForEach(filtered, id: \.self) { book in
                                    let isBookInFavorites = favoriteBooks[section]?.contains(book) == true
                                    MultipleSelectionRowView(book: book, section: section, selectedBooks: $selectedBooks, isBookInFavorites: isBookInFavorites)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isSelectingFavorites = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isSelectingFavorites = false
                        addSelectedBooksToFavorites(selectedBooks: selectedBooks, favoriteBooks: &favoriteBooks)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Title Name")
            .autocorrectionDisabled(true)
        }
    }
}

/// each row of the favorites view
struct MultipleSelectionRowView: View {
    let book: Book
    let section: String
    @Binding var selectedBooks: [String: Set<Book>]
    let isBookInFavorites: Bool
    var body: some View {
        Button(action: {
            if !isBookInFavorites {
                toggleSelection()
            }
        }) {
            HStack {
                Text(book.hindiName)
                    .foregroundColor(isBookInFavorites ? .gray : .primary)
                    .strikethrough(isBookInFavorites, color: .gray)

                Spacer()

                Text(book.author)
                    .italic()
                    .foregroundStyle(.gray)
                    .frame(width: 100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .strikethrough(isBookInFavorites, color: .gray)

                if selectedBooks[section]?.contains(book) == true || isBookInFavorites {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
        }
        .disabled(isBookInFavorites)
    }

    private func toggleSelection() {
        if selectedBooks[section] == nil {
            selectedBooks[section] = []
        }

        if selectedBooks[section]!.contains(book) {
            selectedBooks[section]!.remove(book)
        } else {
            selectedBooks[section]!.insert(book)
        }
    }
}

/// Adds selected books to their respective sections in `favoriteBooks`
func addSelectedBooksToFavorites(
    selectedBooks: [String: Set<Book>],
    favoriteBooks: inout [String: [Book]]
) {
    for (section, books) in selectedBooks {
        if favoriteBooks[section] == nil {
            favoriteBooks[section] = []
        }

        let existingBooks = Set(favoriteBooks[section] ?? [])
        let newBooks = books.subtracting(existingBooks)
        favoriteBooks[section]?.append(contentsOf: newBooks)
    }
}



#Preview{
    FavoritesSelectionView(favoriteBooks: .constant([:]), isSelectingFavorites: .constant(true), isTabViewHidden: .constant(true), searchText: "")
}


