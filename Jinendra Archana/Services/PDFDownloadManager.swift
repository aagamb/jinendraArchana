//
//  PDFDownloadManager.swift
//  Jinendra Archana
//
//  Created for AWS S3 Migration - Step 2.3
//

import Foundation
import Combine

/// Download status for a single PDF
enum DownloadStatus {
    case pending
    case downloading(progress: Double)
    case completed
    case failed(Error)
    case cancelled
}

/// Overall download state for the "all or nothing" approach
enum DownloadState {
    case idle
    case downloading(current: Int, total: Int)
    case completed
    case failed(Error)
    case cancelled
}

/// Manages downloading of PDFs from S3
/// 
/// This manager handles:
/// - Download queue for all PDFs (following "all or nothing" approach)
/// - Progress tracking for individual and overall downloads
/// - Resume capability (can restart failed downloads)
/// - Integration with S3Service and PDFStorageManager
class PDFDownloadManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = PDFDownloadManager()
    
    // MARK: - Development Configuration
    
    /// Returns the expected book count based on S3Service development mode
    /// Development mode: Number of books in devModeBookNames
    /// Production mode: All books from BookData
    var expectedBookCount: Int {
        return S3Service.shared.isDevelopmentMode ? S3Service.shared.devModeBookNames.count : getAllBooks().count
    }
    
    // MARK: - Published Properties
    
    /// Overall download state
    @Published var downloadState: DownloadState = .idle
    
    /// Overall progress (0.0 to 1.0)
    @Published var overallProgress: Double = 0.0
    
    /// Current download count
    @Published var currentDownloadCount: Int = 0
    
    /// Total number of PDFs to download
    @Published var totalDownloadCount: Int = 0
    
    /// Individual download statuses for each book
    @Published var downloadStatuses: [UUID: DownloadStatus] = [:]
    
    // MARK: - Private Properties
    
    private var downloadTasks: [UUID: URLSessionDownloadTask] = [:]
    private var cancellables = Set<AnyCancellable>()
    private let downloadQueue = DispatchQueue(label: "com.jinendraarchana.downloadQueue", qos: .utility)
    private var isDownloading = false
    private var pendingBooks: [Book] = []
    
    // MARK: - Initialization
    
    private init() {
        // Initialize with current state
        updateDownloadState()
    }
    
    // MARK: - Public Download Methods
    
    /// Downloads all PDFs from S3
    /// 
    /// This is the main method for "all or nothing" downloads.
    /// It builds direct S3 URLs for each book and downloads them.
    /// 
    /// - Parameter completion: Optional completion handler called when all downloads complete or fail
    func downloadAllPDFs(completion: ((Result<Int, Error>) -> Void)? = nil) {
        guard !isDownloading else {
            print("⚠️ Download already in progress")
            completion?(.failure(NSError(domain: "PDFDownloadManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Download already in progress"])))
            return
        }
        
        // Verify S3 configuration
        guard S3Service.shared.s3BaseURL != nil else {
            let error = NSError(
                domain: "PDFDownloadManager",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: "S3 base URL not configured. Set S3Service.shared.s3BaseURL"]
            )
            completion?(.failure(error))
            return
        }
        
        // Get all books
        var allBooks = getAllBooks()
        
        // 🚧 DEVELOPMENT MODE: Filter to only books that exist in PDFsDev
        if S3Service.shared.isDevelopmentMode {
            let devBookNames = Set(S3Service.shared.devModeBookNames)
            allBooks = allBooks.filter { devBookNames.contains($0.name) }
            print("🚧 DEV MODE: Using PDFsDev folder with \(allBooks.count) books: \(allBooks.map { $0.name })")
        }
        
        guard !allBooks.isEmpty else {
            print("⚠️ No books to download")
            completion?(.failure(NSError(domain: "PDFDownloadManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "No books to download"])))
            return
        }
        
        // Filter out already downloaded books
        pendingBooks = allBooks.filter { book in
            !PDFStorageManager.shared.pdfExistsLocally(for: book)
        }
        
        guard !pendingBooks.isEmpty else {
            print("✅ All PDFs already downloaded")
            downloadState = .completed
            completion?(.success(0))
            return
        }
        
        // Reset state
        downloadState = .downloading(current: 0, total: pendingBooks.count)
        overallProgress = 0.0
        currentDownloadCount = 0
        totalDownloadCount = pendingBooks.count
        downloadStatuses.removeAll()
        downloadTasks.removeAll()
        isDownloading = true
        
        print("📥 Starting download of \(pendingBooks.count) PDFs")
        
        // Start downloading all books
        downloadBooksSequentially(
            books: pendingBooks,
            completion: completion
        )
    }
    
    /// Downloads all PDFs using async/await
    /// 
    /// - Returns: Number of successfully downloaded PDFs
    func downloadAllPDFs() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            downloadAllPDFs { result in
                switch result {
                case .success(let count):
                    continuation.resume(returning: count)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Resumes downloading all PDFs
    /// 
    /// This will retry any failed downloads and continue with pending ones.
    func resumeDownloads() {
        guard !isDownloading else {
            print("⚠️ Download already in progress")
            return
        }
        
        let allBooks = getAllBooks()
        let failedOrPendingBooks = allBooks.filter { book in
            let status = downloadStatuses[book.id ?? UUID()] ?? .pending
            if case .failed = status {
                return true
            }
            if case .pending = status {
                return !PDFStorageManager.shared.pdfExistsLocally(for: book)
            }
            return false
        }
        
        guard !failedOrPendingBooks.isEmpty else {
            print("✅ No downloads to resume")
            return
        }
        
        downloadAllPDFs(completion: nil)
    }
    
    /// Cancels all ongoing downloads
    func cancelAllDownloads() {
        print("🛑 Cancelling all downloads")
        
        downloadQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Cancel all tasks
            for (bookId, task) in self.downloadTasks {
                task.cancel()
                self.downloadStatuses[bookId] = .cancelled
            }
            
            self.downloadTasks.removeAll()
            self.isDownloading = false
            
            DispatchQueue.main.async {
                self.downloadState = .cancelled
                self.overallProgress = 0.0
            }
        }
    }
    
    // MARK: - Private Download Methods
    
    /// Downloads books sequentially one at a time
    private func downloadBooksSequentially(
        books: [Book],
        completion: ((Result<Int, Error>) -> Void)?
    ) {
        var completedCount = 0
        var failedCount = 0
        let totalCount = books.count
        var currentIndex = 0
        
        // Recursive function to download books one at a time
        func downloadNext() {
            // Check if cancelled
            guard isDownloading else {
                print("🛑 Download cancelled")
                return
            }
            
            // Check if all books are processed
            guard currentIndex < books.count else {
                // All downloads complete
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isDownloading = false
                    
                    if failedCount == 0 {
                        self.downloadState = .completed
                        print("✅ All \(completedCount) PDFs downloaded successfully")
                        completion?(.success(completedCount))
                    } else if completedCount > 0 {
                        // Some succeeded, some failed
                        self.downloadState = .failed(NSError(
                            domain: "PDFDownloadManager",
                            code: -3,
                            userInfo: [NSLocalizedDescriptionKey: "\(failedCount) downloads failed"]
                        ))
                        print("⚠️ Completed \(completedCount) downloads, \(failedCount) failed")
                        completion?(.success(completedCount))
                    } else {
                        // All failed
                        let error = NSError(
                            domain: "PDFDownloadManager",
                            code: -4,
                            userInfo: [NSLocalizedDescriptionKey: "All downloads failed"]
                        )
                        self.downloadState = .failed(error)
                        print("❌ All downloads failed")
                        completion?(.failure(error))
                    }
                }
                return
            }
            
            let book = books[currentIndex]
            let bookId = book.id ?? UUID()
            
            // Update status to downloading
            DispatchQueue.main.async {
                self.downloadStatuses[bookId] = .downloading(progress: 0.0)
            }
            
            print("📥 Downloading \(currentIndex + 1)/\(totalCount): \(book.name)")
            
            // Download the PDF using S3Service (it builds the URL automatically)
            let task = S3Service.shared.downloadPDF(
                for: book,
                progressHandler: { [weak self] progress in
                    DispatchQueue.main.async {
                        self?.downloadStatuses[bookId] = .downloading(progress: progress)
                    }
                },
                completion: { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let url):
                        // Verify file was saved correctly
                        if FileManager.default.fileExists(atPath: url.path) {
                            print("✅ Successfully downloaded: \(book.name)")
                            DispatchQueue.main.async {
                                self.downloadStatuses[bookId] = .completed
                                completedCount += 1
                                self.updateProgress(completed: completedCount, total: totalCount)
                            }
                        } else {
                            print("❌ File not found after download: \(book.name)")
                            DispatchQueue.main.async {
                                self.downloadStatuses[bookId] = .failed(S3ServiceError.noData)
                                failedCount += 1
                            }
                        }
                        
                    case .failure(let error):
                        print("❌ Failed to download \(book.name): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.downloadStatuses[bookId] = .failed(error)
                            failedCount += 1
                        }
                    }
                    
                    // Remove task from tracking
                    self.downloadTasks.removeValue(forKey: bookId)
                    
                    // Move to next book
                    currentIndex += 1
                    downloadNext()
                }
            )
            
            // Store task for potential cancellation (if task was created)
            if let task = task {
                downloadTasks[bookId] = task
            }
        }
        
        // Start downloading
        downloadNext()
    }
    
    // MARK: - Progress Tracking
    
    /// Updates the overall progress based on completed downloads
    private func updateProgress(completed: Int, total: Int) {
        currentDownloadCount = completed
        totalDownloadCount = total
        overallProgress = total > 0 ? Double(completed) / Double(total) : 0.0
        
        downloadState = .downloading(current: completed, total: total)
    }
    
    /// Updates the download state based on current storage status
    func updateDownloadState() {
        var allBooks = getAllBooks()
        
        // 🚧 DEVELOPMENT MODE: Filter to only books that exist in PDFsDev
        if S3Service.shared.isDevelopmentMode {
            let devBookNames = Set(S3Service.shared.devModeBookNames)
            allBooks = allBooks.filter { devBookNames.contains($0.name) }
        }
        
        let downloadedCount = PDFStorageManager.shared.downloadedPDFCount()
        let totalCount = allBooks.count
        
        if downloadedCount >= expectedBookCount && totalCount > 0 {
            downloadState = .completed
            overallProgress = 1.0
            currentDownloadCount = downloadedCount
            totalDownloadCount = totalCount
        } else {
            downloadState = .idle
            overallProgress = Double(downloadedCount) / Double(max(totalCount, 1))
            currentDownloadCount = downloadedCount
            totalDownloadCount = totalCount
        }
    }
    
    /// Gets the download status for a specific book
    /// - Parameter book: The book to check
    /// - Returns: The current download status
    func getDownloadStatus(for book: Book) -> DownloadStatus {
        let bookId = book.id ?? UUID()
        
        // If already downloaded, return completed
        if PDFStorageManager.shared.pdfExistsLocally(for: book) {
            return .completed
        }
        
        // Otherwise return stored status or pending
        return downloadStatuses[bookId] ?? .pending
    }
}

