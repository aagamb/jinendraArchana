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
    
    @State private var selectedBooks : [String: Set<Book>] = [:]
    private let keyOrder = ["Poojan", "Stavan", "Adhyatmik Path", "Bhakti"]
    
    var body: some View{
        NavigationStack{
            List{
                ForEach(keyOrder, id: \.self) { section in
                    if let books = sections[section] {
                        Section(header: Text(section.capitalized)) {
                            ForEach(books, id: \.self) { book in
                                MultipleSelectionRowView(book: book, section:section, selectedBooks:$selectedBooks)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MultipleSelectionRowView: View {
    let book: Book
    let section: String
    @Binding var selectedBooks : [String: Set<Book>]
    
    var body: some View {
        Button(action: {
            toggleSelection()
        }, label: {
            HStack {
                Text("\(book.name)")
                Spacer()
                Text(book.author)
                    .italic()
                    .foregroundStyle(.gray)
                    .frame(width: 100, alignment: .leading)
                    .lineLimit(2)
                if selectedBooks[section]?.contains(book) == false {
                    Image(systemName: "circle.dashed")
                } else {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
        })
    }
    
    private func toggleSelection(){
        if selectedBooks[section] == nil {
            selectedBooks[section] = []
        }
    }
}

#Preview{
    FavoritesSelectionView(favoriteBooks: .constant([:]))
}


