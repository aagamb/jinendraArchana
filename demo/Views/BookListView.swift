//
//  BookListView.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI
import Fuse


/// Function to filter books based on search text using fuzzy logic
func filteredBooks(from books: [Book], searchText: String) -> [Book] {
    if searchText.isEmpty {
        return books  // Show all books when search is empty
    } else {
        let fuse = Fuse()  // Create a Fuse instance

        return books.filter { book in
            if let _ = fuse.search(searchText, in: book.name) {
                return true  // Keep books that have a fuzzy match
            }
            return false
        }
    }
}


struct BookListView: View {
    
    @Binding var isTabViewHidden: Bool
    @State private var searchText: String = ""
    private let keyOrder = ["Poojan", "Path"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(keyOrder, id: \.self) { section in
                    if let books = sections[section] {
                        let filtered = filteredBooks(from: books, searchText: searchText)  // Filter books

                        if !filtered.isEmpty {  // Only show non-empty sections
                            Section(header: Text(section)) {
                                sectionList(for: section, books: filtered, isTabViewHidden: $isTabViewHidden)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Jinendra Archana")
            .searchable(text: $searchText, prompt: "Title Name")
        }
    }
}

@ViewBuilder
private func sectionList(for section: String, books: [Book], isTabViewHidden: Binding<Bool>) -> some View {
    ForEach(books, id: \.id) { book in
        NavigationLink(destination: PDFViewerScreen(pdfName: book.name, isTabViewHidden: isTabViewHidden)) {
            HStack {
                Text(book.hindiName)
                Spacer()
                Text(book.author)
                    .italic()
                    .foregroundStyle(.gray)
                    .frame(width: 100, alignment: .trailing)
                    .lineLimit(2)
                Text("\(book.pgNum)")
                    .frame(width:40, height: 10, alignment: .trailing)
                    .padding(.trailing, 0)
            }
        }
    }
}


#Preview {
    ContentView()
}
