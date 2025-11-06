//
//  PDFPackManager.swift
//  Jinendra Archana
//
//  Created for AWS S3 Migration - Phase 3
//

import Foundation
import Combine

/// Overall download status for the PDF pack
/// Following "all or nothing" approach
enum PDFPackStatus {
    case notDownloaded
    case downloading(current: Int, total: Int, progress: Double)
    case downloaded
    case failed(Error)
}

/// Manages the complete PDF pack download
/// 
/// This manager provides a high-level interface for:
/// - Downloading all PDFs as one complete pack
/// - Tracking overall download status
/// - Calculating total size and count of all PDFs
/// - Managing the entire PDF collection
class PDFPackManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = PDFPackManager()
    
    // MARK: - Published Properties
    
    /// Current pack download status
    @Published var packStatus: PDFPackStatus = .notDownloaded
    
    /// Overall progress (0.0 to 1.0)
    @Published var overallProgress: Double = 0.0
    
    /// Current download count
    @Published var currentDownloadCount: Int = 0
    
    /// Total number of PDFs
    @Published var totalPDFCount: Int = 0
    
    /// Total size of all PDFs (in bytes)
    @Published var totalSizeBytes: Int64 = 0
    
    /// Formatted total size string (e.g., "150.3 MB")
    @Published var formattedTotalSize: String = "0 MB"
    
    /// Formatted downloaded size (for progress tracking)
    @Published var formattedDownloadedSize: String = "0 MB"
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let downloadManager = PDFDownloadManager.shared
    
    // MARK: - Initialization
    
    private init() {
        // Set up observers for download manager updates
        setupObservers()
        
        // Initialize status
        updatePackStatus()
    }
    
    // MARK: - Setup
    
    private func setupObservers() {
        // Observe download state changes
        downloadManager.$downloadState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleDownloadStateChange(state)
            }
            .store(in: &cancellables)
        
        // Observe progress changes
        downloadManager.$overallProgress
            .receive(on: DispatchQueue.main)
            .assign(to: &$overallProgress)
        
        // Observe download count changes
        downloadManager.$currentDownloadCount
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentDownloadCount)
        
        downloadManager.$totalDownloadCount
            .receive(on: DispatchQueue.main)
            .assign(to: &$totalPDFCount)
    }
    
    // MARK: - Public Methods
    
    /// Downloads all PDFs as a complete pack
    /// 
    /// This is the main method for "all or nothing" downloads.
    /// 
    /// - Parameter completion: Optional completion handler
    func downloadAllPDFs(completion: ((Result<Int, Error>) -> Void)? = nil) {
        // Update status to downloading
        packStatus = .downloading(current: 0, total: totalPDFCount, progress: 0.0)
        
        // Start download using PDFDownloadManager
        downloadManager.downloadAllPDFs { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let count):
                    if count == self.totalPDFCount {
                        self.packStatus = .downloaded
                        print("✅ All \(count) PDFs downloaded successfully")
                    } else {
                        // Partial download (shouldn't happen in "all or nothing", but handle it)
                        self.packStatus = .downloading(
                            current: count,
                            total: self.totalPDFCount,
                            progress: Double(count) / Double(self.totalPDFCount)
                        )
                    }
                    
                case .failure(let error):
                    self.packStatus = .failed(error)
                    print("❌ Download failed: \(error.localizedDescription)")
                }
                
                completion?(result)
            }
        }
    }
    
    /// Downloads all PDFs using async/await
    /// 
    /// - Returns: Number of successfully downloaded PDFs
    func downloadAllPDFs() async throws -> Int {
        return try await downloadManager.downloadAllPDFs()
    }
    
    /// Cancels the current download
    func cancelDownload() {
        downloadManager.cancelAllDownloads()
        updatePackStatus()
    }
    
    /// Deletes all downloaded PDFs
    /// 
    /// - Returns: Number of files deleted
    @discardableResult
    func deleteAllPDFs() -> Int {
        let deletedCount = PDFStorageManager.shared.deleteAllPDFs()
        updatePackStatus()
        return deletedCount
    }
    
    /// Updates the pack status based on current storage state
    func updatePackStatus() {
        let storageManager = PDFStorageManager.shared
        var allBooks = getAllBooks()
        
        // 🚧 DEVELOPMENT MODE: Filter to only books that exist in PDFsDev
        if S3Service.shared.isDevelopmentMode {
            let devBookNames = Set(S3Service.shared.devModeBookNames)
            allBooks = allBooks.filter { devBookNames.contains($0.name) }
        }
        
        let downloadedCount = storageManager.downloadedPDFCount()
        let totalCount = allBooks.count
        let expectedCount = S3Service.shared.isDevelopmentMode ? S3Service.shared.devModeBookNames.count : totalCount
        
        totalPDFCount = totalCount
        
        // Calculate total size
        totalSizeBytes = storageManager.totalDownloadedSize()
        formattedTotalSize = storageManager.formattedTotalDownloadedSize()
        
        // Update downloaded size
        let downloadedSize = storageManager.totalDownloadedSize()
        formattedDownloadedSize = formatBytes(downloadedSize)
        
        // Update status
        if downloadedCount >= expectedCount && totalCount > 0 {
            packStatus = .downloaded
            overallProgress = 1.0
            currentDownloadCount = downloadedCount
        } else if downloadedCount == 0 {
            packStatus = .notDownloaded
            overallProgress = 0.0
            currentDownloadCount = 0
        } else {
            // Partial state (shouldn't happen in "all or nothing", but track it)
            let progress = Double(downloadedCount) / Double(max(totalCount, 1))
            packStatus = .downloading(
                current: downloadedCount,
                total: totalCount,
                progress: progress
            )
            overallProgress = progress
            currentDownloadCount = downloadedCount
        }
    }
    
    /// Gets the total size of all PDFs (if we could download them)
    /// 
    /// Note: This is an estimate based on local files if available,
    /// or returns nil if we can't determine the size
    /// 
    /// - Returns: Total size in bytes, or nil if unknown
    func getEstimatedTotalSize() -> Int64? {
        // If all PDFs are downloaded, return actual size
        if case .downloaded = packStatus {
            return totalSizeBytes
        }
        
        // Otherwise, we'd need to query S3 for file sizes
        // For now, return nil to indicate unknown
        return nil
    }
    
    /// Gets formatted estimated total size
    /// 
    /// - Returns: Formatted string, or "Unknown" if size is unknown
    func getFormattedEstimatedTotalSize() -> String {
        if let estimatedSize = getEstimatedTotalSize() {
            return formatBytes(estimatedSize)
        }
        return "Unknown"
    }
    
    // MARK: - Private Methods
    
    private func handleDownloadStateChange(_ state: DownloadState) {
        switch state {
        case .idle:
            updatePackStatus()
            
        case .downloading(let current, let total):
            let progress = total > 0 ? Double(current) / Double(total) : 0.0
            packStatus = .downloading(current: current, total: total, progress: progress)
            overallProgress = progress
            currentDownloadCount = current
            totalPDFCount = total
            
            // Update downloaded size as we progress
            let downloadedSize = PDFStorageManager.shared.totalDownloadedSize()
            formattedDownloadedSize = formatBytes(downloadedSize)
            
        case .completed:
            packStatus = .downloaded
            overallProgress = 1.0
            updatePackStatus()
            
        case .failed(let error):
            packStatus = .failed(error)
            
        case .cancelled:
            updatePackStatus()
        }
    }
    
    /// Formats bytes into a human-readable string
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

