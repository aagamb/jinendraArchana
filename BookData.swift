//
//  BookData.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/26/25.
//

import Foundation

struct Book: Hashable, Identifiable{
    let name: String
    let author: String
    let pgNum: Int
    let id = UUID()
}

struct Category: Hashable, Identifiable{
    let name: String
    let books: [Book]
    let id = UUID()
}

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
    "Poojan": [
        Book(name: "Adi", author: "Rick", pgNum: 5),
        Book(name: "Mahavir", author: "BigLongName Comes Here", pgNum: 200)
    ],
    "Path": [
        Book(name: "Vee", author: "Rick", pgNum: 5),
        Book(name: "Jinendra Archana", author: "BigLongName Comes Here", pgNum: 200)
    ]
]

