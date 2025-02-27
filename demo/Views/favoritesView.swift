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
    @State private var favoriteBooks: [String: [Book]] = [
        "poojan": [
            Book(name: "Bhagavad Gita", author: "Rick", pgNum: 5),
            Book(name: "Upanishads", author: "Rick", pgNum: 5),
            Book(name: "The Yoga Sutras", author: "Rick", pgNum: 5)
        ],
        "path": [
            Book(name: "Atomic Habits", author: "Rick", pgNum: 5),
            Book(name: "The Power of Now", author: "Rick", pgNum: 5),
            Book(name: "Deep Work", author: "Rick", pgNum: 5)
        ],
        "sath": [
            Book(name: "Atomic Habits", author: "Rick", pgNum: 5),
            Book(name: "The Power of Now", author: "Rick", pgNum: 5),
            Book(name: "Deep Work", author: "Rick", pgNum: 5)
        ],
        "dath": [
            Book(name: "Atomic Habits", author: "Rick", pgNum: 5),
            Book(name: "The Power of Now", author: "Rick", pgNum: 5),
            Book(name: "Deep Work", author: "Rick", pgNum: 5)
        ],
        "qath": [
            Book(name: "Atomic Habits", author: "Rick", pgNum: 5),
            Book(name: "The Power of Now", author: "Rick", pgNum: 5),
            Book(name: "Deep Work", author: "Rick", pgNum: 5)
        ]
    ]
    
    var body: some View {
        NavigationStack {
            if favoriteBooks.isEmpty {
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
            } else {
                ZStack{
                    let keyOrder = ["poojan", "path", "sath", "dath", "qath"]
                    List {
                        ForEach(keyOrder, id: \.self) { key in
                            if let books = favoriteBooks[key] {
                                Section(header: Text(key.capitalized)) {
                                    ForEach(books) { book in
                                        NavigationLink(destination: PDFViewerScreen(pdfName: book.name, isTabViewHidden: $isTabViewHidden)) {
                                            Text(book.name)
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    .navigationTitle("Favorites")
                    .sheet(isPresented: $isSelectingFavorites) {
                        FavoritesSelectionView(favoriteBooks: $favoriteBooks, isSelectingFavorites: $isSelectingFavorites)
                    }
                    
                    // Floating Button (Bottom-Right)
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
            }
        }
    }
}


