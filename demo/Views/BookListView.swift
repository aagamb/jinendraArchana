//
//  BookListView.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI


struct BookListView: View {
    
    @Binding var isTabViewHidden: Bool
    @State private var searchText: String = ""
    private let keyOrder = ["Poojan", "Path"]

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(keyOrder, id: \.self) { section in
                    Section(header: Text(section)) {
                        bookList(for: section, isTabViewHidden: $isTabViewHidden)
                    }
                }
            }
            .navigationTitle("Jinendra Archana")
            .searchable(text: $searchText, prompt: "Title Name")
            .toolbar { EditButton() }
        }
    }
}

@ViewBuilder
private func bookList(for section: String, isTabViewHidden: Binding<Bool>) -> some View {
    if let books = sections[section] {
        ForEach(books, id: \.id) { book in
            NavigationLink(destination: PDFViewerScreen(pdfName: book.name, isTabViewHidden: isTabViewHidden)) {
                HStack {
                    Text(book.name)
                    Spacer()
                    Text(book.author)
                    Text("\(book.pgNum)") // Convert Int to String
                }
            }
        }
    }
}
