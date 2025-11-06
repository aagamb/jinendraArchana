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

// MARK: - PDF Loading State

enum PDFLoadingState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}

// MARK: - PDF Viewer Wrapper with Loading State

struct PDFViewerWithState: View {
    let pdfName: String
    @Binding var isNavBarHidden: Bool
    @Binding var orientation: UIDeviceOrientation
    @StateObject private var loadingManager = PDFLoadingManager()
    
    var body: some View {
        ZStack {
            // The actual PDF viewer
            PDFViewer(
                pdfName: pdfName,
                isNavBarHidden: $isNavBarHidden,
                orientation: $orientation,
                loadingManager: loadingManager
            )
            
            // Loading overlay
            if loadingManager.loadingState == .loading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text("Loading PDF from cloud...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            
            // Error overlay
            if case .error(let message) = loadingManager.loadingState {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Failed to Load PDF")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button("Try Again") {
                        loadingManager.loadingState = .idle
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(32)
                .background(.regularMaterial)
                .cornerRadius(20)
                .shadow(radius: 20)
            }
        }
    }
}

// MARK: - PDF Loading Manager

class PDFLoadingManager: ObservableObject {
    @Published var loadingState: PDFLoadingState = .idle
}

// MARK: - PDF Viewer UIViewRepresentable

struct PDFViewer: UIViewRepresentable {
    let pdfName: String
    @Binding var isNavBarHidden: Bool
    @Binding var orientation: UIDeviceOrientation
    @ObservedObject var loadingManager: PDFLoadingManager
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = false
        pdfView.displaysPageBreaks = false
        
        // Try to load PDF
        loadPDF(into: pdfView)
        
        pdfView.minScaleFactor = 1.0  // Minimum zoom level
        pdfView.maxScaleFactor = 2.5  // Maximum zoom level
        pdfView.scaleFactor = 1.0     // Default zoom level
        
        adjustZoom(pdfView: pdfView, orientation: orientation)
        
        return pdfView
    }
    
    func loadPDF(into pdfView: PDFView) {
        // Priority 1: Check local storage (Documents/PDFs/)
        let storageManager = PDFStorageManager.shared
        if let book = findBook(by: pdfName) {
            let localURL = storageManager.localFileURL(for: book)
            if FileManager.default.fileExists(atPath: localURL.path) {
                pdfView.document = PDFDocument(url: localURL)
                DispatchQueue.main.async {
                    loadingManager.loadingState = .loaded
                }
                print("✅ Loaded '\(pdfName)' from local storage")
                return
            }
            
            // Priority 2: Check bundle (for backward compatibility)
            if let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("PDFs/\(pdfName).pdf"),
               FileManager.default.fileExists(atPath: bundleURL.path) {
                pdfView.document = PDFDocument(url: bundleURL)
                DispatchQueue.main.async {
                    loadingManager.loadingState = .loaded
                }
                print("✅ Loaded '\(pdfName)' from bundle")
                return
            }
            
            // Priority 3: Stream from S3 (on-demand viewing)
            print("📡 Streaming '\(pdfName)' from S3...")
            DispatchQueue.main.async {
                loadingManager.loadingState = .loading
            }
            
            S3Service.shared.streamPDFForViewing(for: book) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let pdfDocument = PDFDocument(data: data) {
                            pdfView.document = pdfDocument
                            loadingManager.loadingState = .loaded
                            print("✅ Successfully streamed '\(pdfName)' from S3")
                        } else {
                            loadingManager.loadingState = .error("Invalid PDF file format")
                            print("❌ Failed to create PDF document from streamed data")
                        }
                    case .failure(let error):
                        let errorMessage = getReadableErrorMessage(error)
                        loadingManager.loadingState = .error(errorMessage)
                        print("❌ Failed to stream '\(pdfName)': \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // Fallback: Try bundle if book not found
            if let pdfURL = Bundle.main.resourceURL?.appendingPathComponent("PDFs/\(pdfName).pdf") {
                if FileManager.default.fileExists(atPath: pdfURL.path) {
                    pdfView.document = PDFDocument(url: pdfURL)
                    DispatchQueue.main.async {
                        loadingManager.loadingState = .loaded
                    }
                    print("✅ Loaded '\(pdfName)' from bundle (fallback)")
                } else {
                    DispatchQueue.main.async {
                        loadingManager.loadingState = .error("PDF '\(pdfName)' not found")
                    }
                    print("❌ PDF not found: \(pdfName)")
                }
            } else {
                DispatchQueue.main.async {
                    loadingManager.loadingState = .error("PDF '\(pdfName)' not found")
                }
            }
        }
    }
    
    private func getReadableErrorMessage(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. Please check your network and try again."
            case .timedOut:
                return "Connection timed out. Please try again."
            case .cannotFindHost, .cannotConnectToHost:
                return "Cannot connect to server. Please try again later."
            default:
                return "Network error: \(urlError.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
    
    private func findBook(by name: String) -> Book? {
        let allBooks = getAllBooks()
        return allBooks.first { $0.name == name }
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
