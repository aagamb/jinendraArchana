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
        let searchTextLower = searchText.lowercased()
        
        for book in books {
            let bookNameLower = book.name.lowercased()
            
            // Check if search text appears anywhere in the book name
            if bookNameLower.contains(searchTextLower) {
                filteredBooks.append(book)
            }
            // Also check with Levenshtein distance for fuzzy matching
            else if levenshteinDistance(bookNameLower, searchTextLower) <= 3 {
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
    @State private var collapsedSections: Set<String> = []
//    @Binding var isAutoScrolling: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(keyOrder, id: \.self) { section in
                    if let books = sections[section] {
                        let filtered = filteredBooks(from: books, searchText: searchText)  // Filter books

                        if !filtered.isEmpty {  // Only show non-empty sections
                            Section(header: sectionHeader(for: section)) {
                                if !collapsedSections.contains(section) {
                                    sectionList(for: section, books: filtered, isTabViewHidden: $isTabViewHidden)
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
            }
            .animation(.default, value: collapsedSections)
            .navigationTitle("Jinendra Archana")
            .searchable(text: $searchText, prompt: "Title Name")
            .autocorrectionDisabled(true)
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



