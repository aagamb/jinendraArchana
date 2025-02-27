//
//  PDFViewer.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
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
