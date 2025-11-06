//
//  DownloadSettingsView.swift
//  Jinendra Archana
//
//  Created for AWS S3 Migration - Phase 4.2
//

import SwiftUI

struct DownloadSettingsView: View {
    @ObservedObject private var packManager = PDFPackManager.shared
    @State private var showDownloadConfirmation = false
    @State private var showDeleteConfirmation = false
    @State private var isDownloading = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                Text("PDF Downloads")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 8)
            
            // 🚧 Development Mode Warning
            if S3Service.shared.isDevelopmentMode {
                HStack(spacing: 8) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .foregroundColor(.orange)
                    Text("DEV MODE: Using PDFsDev folder (\(S3Service.shared.devModeBookNames.count) books)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
            
            Divider()
            
            // Storage Info
            storageInfoSection
            
            Divider()
            
            // Download Status & Actions
            downloadActionsSection
            
            Spacer()
        }
        .onAppear {
            packManager.updatePackStatus()
        }
    }
    
    // MARK: - Storage Info Section
    
    private var storageInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Storage Information")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "doc.fill")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                Text("Total PDFs:")
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(packManager.totalPDFCount)")
                    .fontWeight(.medium)
            }
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .frame(width: 24)
                Text("Downloaded:")
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(packManager.currentDownloadCount) / \(packManager.totalPDFCount)")
                    .fontWeight(.medium)
            }
            
            HStack {
                Image(systemName: "internaldrive.fill")
                    .foregroundColor(.orange)
                    .frame(width: 24)
                Text("Storage Used:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(packManager.formattedTotalSize)
                    .fontWeight(.medium)
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Download Actions Section
    
    private var downloadActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Status indicator
            statusIndicator
            
            // Progress bar (when downloading)
            if case .downloading = packManager.packStatus {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Downloading...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(packManager.overallProgress * 100))%")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    ProgressView(value: packManager.overallProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(.blue)
                    
                    Text("\(packManager.currentDownloadCount) of \(packManager.totalPDFCount) PDFs downloaded")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        packManager.cancelDownload()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Cancel Download")
                        }
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.vertical, 8)
                    }
                }
                .padding(16)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Action buttons
            if case .downloaded = packManager.packStatus {
                // All downloaded - show delete option
                VStack(spacing: 12) {
                    Text("All PDFs are available offline")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Delete All PDFs")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .alert("Delete All PDFs?", isPresented: $showDeleteConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            deleteAllPDFs()
                        }
                    } message: {
                        Text("This will delete all downloaded PDFs from your device. You can re-download them anytime from the cloud.")
                    }
                }
            } else if case .downloading = packManager.packStatus {
                // Downloading - handled above with progress bar
                EmptyView()
            } else {
                // Not downloaded - show download option
                Button(action: {
                    showDownloadConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("Download All PDFs")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .alert("Download All PDFs?", isPresented: $showDownloadConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Download") {
                        downloadAllPDFs()
                    }
                } message: {
                    Text("This will download all \(packManager.totalPDFCount) PDFs for offline access. Make sure you have a stable internet connection.")
                }
            }
            
            // Error handling
            if case .failed(let error) = packManager.packStatus {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Download Failed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showDownloadConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Try Again")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                    }
                }
                .padding(16)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Status Indicator
    
    private var statusIndicator: some View {
        HStack(spacing: 12) {
            statusIcon
            
            VStack(alignment: .leading, spacing: 4) {
                Text(statusTitle)
                    .font(.headline)
                
                Text(statusSubtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(statusBackgroundColor)
        .cornerRadius(12)
    }
    
    private var statusIcon: some View {
        Group {
            switch packManager.packStatus {
            case .notDownloaded:
                Image(systemName: "cloud")
                    .foregroundColor(.blue)
                    .font(.system(size: 32))
            case .downloading:
                ProgressView()
                    .scaleEffect(1.5)
            case .downloaded:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 32))
            case .failed:
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 32))
            }
        }
    }
    
    private var statusTitle: String {
        switch packManager.packStatus {
        case .notDownloaded:
            return "Online Mode"
        case .downloading:
            return "Downloading..."
        case .downloaded:
            return "Offline Mode"
        case .failed:
            return "Download Failed"
        }
    }
    
    private var statusSubtitle: String {
        switch packManager.packStatus {
        case .notDownloaded:
            return "PDFs will stream from cloud when opened"
        case .downloading(let current, let total, _):
            return "Downloading \(current) of \(total) PDFs"
        case .downloaded:
            return "All PDFs available offline"
        case .failed:
            return "Some PDFs could not be downloaded"
        }
    }
    
    private var statusBackgroundColor: Color {
        switch packManager.packStatus {
        case .notDownloaded:
            return Color.blue.opacity(0.1)
        case .downloading:
            return Color.blue.opacity(0.1)
        case .downloaded:
            return Color.green.opacity(0.1)
        case .failed:
            return Color.orange.opacity(0.1)
        }
    }
    
    // MARK: - Actions
    
    private func downloadAllPDFs() {
        isDownloading = true
        
        packManager.downloadAllPDFs { result in
            isDownloading = false
            
            switch result {
            case .success(let count):
                print("✅ Successfully downloaded \(count) PDFs")
            case .failure(let error):
                print("❌ Download failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteAllPDFs() {
        let deletedCount = packManager.deleteAllPDFs()
        print("🗑️ Deleted \(deletedCount) PDFs")
    }
}

// MARK: - Preview

#Preview {
    DownloadSettingsView()
        .padding()
}

