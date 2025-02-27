//
//  BookData.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/26/25.
//

import Foundation

struct Book: Hashable, Identifiable{
    let name: String
    let id = UUID()
}

struct Category: Hashable, Identifiable{
    let name: String
    let books: [Book]
    let id = UUID()
}

//    @State private var isNavBarHidden = false

//let sections: [Category] = [
//    Category(name: "Poojan",
//            books: [Book(name: "Adi"),
//                    Book(name: "Mahavir")]
//            ),
//    Category(name: "Path",
//            books: [Book(name: "Vee"),
//                    Book(name: "Jinendra Archana")]
//            )
//]

let sections: [String: [Book]] = [
    "Poojan" : [
        Book(name: "Adi"),
        Book(name: "Mahavir")
    ]
     ,
    "Path" : [
        Book(name: "Vee"),
        Book(name: "Jinendra Archana")
    ]
]
