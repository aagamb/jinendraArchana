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
        
        if let pdfURL = Bundle.main.resourceURL?.appendingPathComponent("PDFs/\(pdfName).pdf") {
            if FileManager.default.fileExists(atPath: pdfURL.path) {
                pdfView.document = PDFDocument(url: pdfURL)
                print("'\(pdfName)' is now being displayed")
            } else {
                print("PDF not found at path: \(pdfURL.path)")
            }
        }

        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
