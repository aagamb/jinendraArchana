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
//    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @Binding var orientation: UIDeviceOrientation
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = false
        pdfView.displaysPageBreaks = false
        
        pdfView.minScaleFactor = 1.0  // Minimum zoom level
        pdfView.maxScaleFactor = 3.0  // Maximum zoom level
        
        if let pdfURL = Bundle.main.resourceURL?.appendingPathComponent("PDFs/\(pdfName).pdf") {
            if FileManager.default.fileExists(atPath: pdfURL.path) {
                pdfView.document = PDFDocument(url: pdfURL)
                print("'\(pdfName)' is now being displayed")
            } else {
                print("PDF not found at path: \(pdfURL.path)")
            }
        }
        
        adjustZoom(pdfView: pdfView, orientation: orientation)
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        DispatchQueue.main.async {
            adjustZoom(pdfView: uiView, orientation: orientation)
        }
    }
    
    private func adjustZoom(pdfView: PDFView, orientation: UIDeviceOrientation){
        let portraitZoom: CGFloat = 1.1
        let landscapeZoom: CGFloat = 2.0
        
        if orientation.isLandscape {
            pdfView.scaleFactor = landscapeZoom
            print("Landscape mode: Zoom set to \(landscapeZoom)x")
        } else if orientation.isPortrait {
            pdfView.scaleFactor = portraitZoom
            print("Portrait mode: Zoom set to \(portraitZoom)x")
        }
    }
}
