// The goal now - add a search bar
// Finish the favorites menu
// Set autozoom to 1.2x times the default zoom level when turning from portrait to landscape
// Add a search functionality when hiding the big dictionary

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    let pdfName: String
    @Binding var isNavBarHidden: Bool
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = false
        pdfView.displaysPageBreaks = false
        
        if let pdfURL = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: pdfURL)
        }
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct ContentView: View {
    
    @State private var isTabViewHidden = false
            
    var body: some View {
        
        NavigationView {
            
            TabView {
                BookListView(isTabViewHidden: $isTabViewHidden)
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Book")
                    }

                FavoritesView(isTabViewHidden: $isTabViewHidden)
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
            }
                
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
                    Text("\(book.pgNum)")
                }
            }
        }
    }
}

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

struct FavoritesSelectionView: View{
    @Binding var favoriteBooks: [String: [Book]]
    @Binding var isSelectingFavorites: Bool
    
    var body: some View{
        Text("hi")
    }
}

struct PDFViewerScreen: View {
    let pdfName: String
    @State private var isNavBarHidden = false
    @Binding var isTabViewHidden: Bool
    
    var body: some View {
        ZStack {
            PDFViewer(pdfName: pdfName, isNavBarHidden: $isNavBarHidden)
                .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)){
                        isNavBarHidden.toggle()
                    }
                }
                .onAppear {
                    isTabViewHidden = true
                }
                .onDisappear {
                    isTabViewHidden = false
                }
        }
        .navigationBarHidden(isNavBarHidden)
        .toolbar(isTabViewHidden ? .hidden : .visible, for: .tabBar)
        
    }
}

#Preview {
    ContentView()
}
