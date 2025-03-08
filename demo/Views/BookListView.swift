//
//  BookListView.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI


///Function to filter books based on search text
func filteredBooks(from books: [Book], searchText: String) -> [Book] {
    if searchText.isEmpty {
        return books
    }
    else {
        var filteredBooks : [Book] = []
        for book in books {
            let bookSubSeq = book.name.prefix(searchText.count)
            if levenshteinDistance(bookSubSeq.lowercased(), searchText.lowercased()) <= 3 {
                filteredBooks.append(book)
            }
        }
        return filteredBooks
            
    }
}

///Function to calculate the which books to be filtered
func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
    let empty = Array(repeating: 0, count: s2.count + 1)
    var previous = [Int](0...s2.count)
    var current = empty

    for (i, char1) in s1.enumerated() {
        current[0] = i + 1

        for (j, char2) in s2.enumerated() {
            current[j + 1] = char1 == char2
                ? previous[j]
                : min(previous[j], previous[j + 1], current[j]) + 1
        }
        previous = current
    }
    return previous[s2.count]
}

struct BookListView: View {
    
    @Binding var isTabViewHidden: Bool
    @State private var searchText: String = ""
    private let keyOrder = ["Stavan", "Poojan", "Adhyatmik Path", "Bhakti"]
    
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
            .autocorrectionDisabled(true)
        }
    }
}

@ViewBuilder
func sectionList(for section: String, books: [Book], isTabViewHidden: Binding<Bool>) -> some View {
    ForEach(books, id: \.id) { book in
        NavigationLink(destination: PDFViewerScreen(pdfName: book.name, isTabViewHidden: isTabViewHidden)) {
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
}



