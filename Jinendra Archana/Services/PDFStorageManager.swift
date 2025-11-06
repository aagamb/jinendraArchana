//
//  PDFStorageManager.swift
//  Jinendra Archana
//
//  Created for AWS S3 Migration - Step 1.3
//

import Foundation

/// Manages local storage for downloaded PDF files
/// 
/// This manager handles:
/// - Creating and maintaining the PDFs/ directory in Documents
/// - Providing file paths for local PDF storage
/// - Following the "all or nothing" download approach
class PDFStorageManager {
    
    // MARK: - Singleton
    static let shared = PDFStorageManager()
    
    // MARK: - Properties
    
    /// The base directory for PDF storage (Documents/PDFs/)
    private let pdfsDirectory: URL
    
    // MARK: - Initialization
    
    private init() {
        // Get the Documents directory
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        
        // Create PDFs subdirectory path
        pdfsDirectory = documentsDirectory.appendingPathComponent("PDFs", isDirectory: true)
        
        // Ensure the directory exists
        createPDFsDirectoryIfNeeded()
    }
    
    // MARK: - Directory Setup
    
    /// Creates the PDFs directory if it doesn't exist
    /// This is called during initialization to ensure the directory structure is ready
    private func createPDFsDirectoryIfNeeded() {
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: pdfsDirectory.path) {
            do {
                try fileManager.createDirectory(
                    at: pdfsDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                print("✅ Created PDFs directory at: \(pdfsDirectory.path)")
            } catch {
                print("❌ Failed to create PDFs directory: \(error.localizedDescription)")
            }
        } else {
            print("✅ PDFs directory already exists at: \(pdfsDirectory.path)")
        }
    }
    
    // MARK: - Path Methods
    
    /// Returns the local file URL for a given book's PDF
    /// Format: Documents/PDFs/{Book.name}.pdf
    /// - Parameter book: The book to get the local path for
    /// - Returns: The file URL where the PDF should be stored locally
    func localFileURL(for book: Book) -> URL {
        return pdfsDirectory.appendingPathComponent(book.localFileName())
    }
    
    /// Returns the local file path (string) for a given book's PDF
    /// - Parameter book: The book to get the local path for
    /// - Returns: The file path string where the PDF should be stored locally
    func localFilePath(for book: Book) -> String {
        return localFileURL(for: book).path
    }
    
    /// Returns the base directory URL for PDFs
    /// - Returns: The Documents/PDFs/ directory URL
    func getPDFsDirectory() -> URL {
        return pdfsDirectory
    }
    
    // MARK: - File Existence Check
    
    /// Checks if a PDF exists locally for a given book
    /// - Parameter book: The book to check
    /// - Returns: True if the PDF file exists locally, false otherwise
    func pdfExistsLocally(for book: Book) -> Bool {
        let filePath = localFilePath(for: book)
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    /// Checks if all PDFs are downloaded locally
    /// Used for "all or nothing" approach - either all are downloaded or none
    /// - Returns: True if all PDFs exist locally, false otherwise
    func allPDFsDownloaded() -> Bool {
        let allBooks = getAllBooks()
        
        // If no books, return false
        guard !allBooks.isEmpty else { return false }
        
        // Check if all PDFs exist locally
        return allBooks.allSatisfy { pdfExistsLocally(for: $0) }
    }
    
    /// Returns the count of PDFs that are downloaded locally
    /// - Returns: Number of PDFs that exist in local storage
    func downloadedPDFCount() -> Int {
        let allBooks = getAllBooks()
        return allBooks.filter { pdfExistsLocally(for: $0) }.count
    }
    
    // MARK: - File Saving
    
    /// Saves PDF data to local storage
    /// - Parameters:
    ///   - data: The PDF data to save
    ///   - book: The book this PDF belongs to
    /// - Returns: The URL where the file was saved, or nil if saving failed
    @discardableResult
    func savePDF(data: Data, for book: Book) -> URL? {
        let fileURL = localFileURL(for: book)
        
        do {
            // Ensure directory exists
            let directory = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            // Write data to file
            try data.write(to: fileURL, options: .atomic)
            print("✅ Saved PDF for \(book.name) at: \(fileURL.path)")
            return fileURL
        } catch {
            print("❌ Failed to save PDF for \(book.name): \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Saves PDF from a source URL to local storage
    /// - Parameters:
    ///   - sourceURL: The source file URL (e.g., from a download)
    ///   - book: The book this PDF belongs to
    /// - Returns: The destination URL where the file was saved, or nil if saving failed
    @discardableResult
    func savePDF(from sourceURL: URL, for book: Book) -> URL? {
        let destinationURL = localFileURL(for: book)
        
        do {
            // Ensure directory exists
            let directory = destinationURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            // Remove existing file if it exists
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            // Copy file from source to destination
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            print("✅ Saved PDF for \(book.name) from \(sourceURL.path) to \(destinationURL.path)")
            return destinationURL
        } catch {
            print("❌ Failed to save PDF for \(book.name): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Cache Management
    
    /// Deletes a specific PDF from local storage
    /// - Parameter book: The book whose PDF should be deleted
    /// - Returns: True if deletion was successful, false otherwise
    @discardableResult
    func deletePDF(for book: Book) -> Bool {
        let fileURL = localFileURL(for: book)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("⚠️ PDF file does not exist for \(book.name)")
            return false
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("✅ Deleted PDF for \(book.name)")
            return true
        } catch {
            print("❌ Failed to delete PDF for \(book.name): \(error.localizedDescription)")
            return false
        }
    }
    
    /// Deletes all downloaded PDFs from local storage
    /// Used for "all or nothing" approach - clears all downloaded files
    /// - Returns: Number of files successfully deleted
    @discardableResult
    func deleteAllPDFs() -> Int {
        let allBooks = getAllBooks()
        var deletedCount = 0
        
        for book in allBooks {
            if deletePDF(for: book) {
                deletedCount += 1
            }
        }
        
        print("✅ Deleted \(deletedCount) PDF files")
        return deletedCount
    }
    
    /// Clears all files from the PDFs directory
    /// This is more aggressive than deleteAllPDFs() - it removes everything in the directory
    /// - Returns: True if cleanup was successful, false otherwise
    @discardableResult
    func clearCache() -> Bool {
        let fileManager = FileManager.default
        
        guard fileManager.fileExists(atPath: pdfsDirectory.path) else {
            print("⚠️ PDFs directory does not exist")
            return false
        }
        
        do {
            // Get all files in the directory
            let files = try fileManager.contentsOfDirectory(
                at: pdfsDirectory,
                includingPropertiesForKeys: nil,
                options: []
            )
            
            // Delete each file
            for file in files {
                try fileManager.removeItem(at: file)
            }
            
            print("✅ Cleared cache: deleted \(files.count) files")
            return true
        } catch {
            print("❌ Failed to clear cache: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - File Size Tracking
    
    /// Returns the file size of a specific PDF in bytes
    /// - Parameter book: The book to get the file size for
    /// - Returns: File size in bytes, or nil if file doesn't exist
    func fileSize(for book: Book) -> Int64? {
        let fileURL = localFileURL(for: book)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            if let size = attributes[FileAttributeKey.size] as? Int64 {
                return size
            } else if let size = attributes[FileAttributeKey.size] as? NSNumber {
                return size.int64Value
            }
            return nil
        } catch {
            print("❌ Failed to get file size for \(book.name): \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Returns the file size of a specific PDF as a formatted string
    /// - Parameter book: The book to get the file size for
    /// - Returns: Formatted file size string (e.g., "1.5 MB"), or nil if file doesn't exist
    func formattedFileSize(for book: Book) -> String? {
        guard let bytes = fileSize(for: book) else {
            return nil
        }
        return formatBytes(bytes)
    }
    
    /// Returns the total size of all downloaded PDFs in bytes
    /// - Returns: Total size in bytes
    func totalDownloadedSize() -> Int64 {
        let allBooks = getAllBooks()
        var totalSize: Int64 = 0
        
        for book in allBooks {
            if let size = fileSize(for: book) {
                totalSize += size
            }
        }
        
        return totalSize
    }
    
    /// Returns the total size of all downloaded PDFs as a formatted string
    /// - Returns: Formatted total size string (e.g., "150.3 MB")
    func formattedTotalDownloadedSize() -> String {
        let totalSize = totalDownloadedSize()
        return formatBytes(totalSize)
    }
    
    /// Returns the average file size of downloaded PDFs
    /// - Returns: Average size in bytes, or nil if no PDFs are downloaded
    func averageFileSize() -> Int64? {
        let downloadedCount = downloadedPDFCount()
        guard downloadedCount > 0 else {
            return nil
        }
        
        return totalDownloadedSize() / Int64(downloadedCount)
    }
    
    /// Returns the average file size as a formatted string
    /// - Returns: Formatted average size string, or nil if no PDFs are downloaded
    func formattedAverageFileSize() -> String? {
        guard let averageSize = averageFileSize() else {
            return nil
        }
        return formatBytes(averageSize)
    }
    
    // MARK: - Helper Methods
    
    /// Formats bytes into a human-readable string
    /// - Parameter bytes: The number of bytes
    /// - Returns: Formatted string (e.g., "1.5 MB", "500 KB")
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

