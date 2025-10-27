//
//  PDFViewer.swift
//  Jinendra Archana
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI
import PDFKit
import UIKit

struct PDFViewer: UIViewRepresentable {
    let pdfName: String
    @Binding var isNavBarHidden: Bool
    @Binding var orientation: UIDeviceOrientation
    
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
        
        pdfView.minScaleFactor = 1.0  // Minimum zoom level
        pdfView.maxScaleFactor = 2.5  // Maximum zoom level
        pdfView.scaleFactor = 1.0     // Default zoom level
        
        adjustZoom(pdfView: pdfView, orientation: orientation)
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        DispatchQueue.main.async {
            adjustZoom(pdfView: uiView, orientation: orientation)
        }
    }
    
    private func adjustZoom(pdfView: PDFView, orientation: UIDeviceOrientation){
        let portraitZoom: CGFloat = 1.0
        let landscapeZoom: CGFloat = 2.3
        
        if orientation.isLandscape {
//            pdfView.scaleFactor = landscapeZoom
            pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit * 1.2
            print("Landscape mode: Zoom set to \(landscapeZoom)x")
        } else if orientation.isPortrait {
            pdfView.scaleFactor = portraitZoom
            print("Portrait mode: Zoom set to \(portraitZoom)x")
        }
    }
}
