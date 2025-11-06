//
//  S3Service.swift
//  Jinendra Archana
//
//  Created for AWS S3 Migration - Step 2.1
//

import Foundation

/// Errors that can occur during S3 operations
enum S3ServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case httpError(Int)
    case noData
    case invalidResponse
    case invalidConfiguration
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .noData:
            return "No data received from server"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidConfiguration:
            return "S3 configuration is invalid. Set S3Service.shared.s3BaseURL"
        }
    }
}

/// Service for interacting with AWS S3 using public URLs
/// 
/// This service handles:
/// - Building direct S3 URLs for PDFs
/// - Downloading PDFs from S3
/// - Error handling and retry logic
/// - Streaming support for on-demand viewing
/// - Following the "all or nothing" download approach
class S3Service {
    
    // MARK: - Singleton
    static let shared = S3Service()
    
    // MARK: - Configuration
    
    /// S3 bucket base URL
    /// Format: "https://your-bucket-name.s3.region.amazonaws.com" or "https://your-bucket-name.s3-region.amazonaws.com"
    /// Example: "https://jinendra-archana-pdfs.s3.us-east-1.amazonaws.com"
    var s3BaseURL: String?
    
    /// 🚧 DEVELOPMENT MODE: Set to true to use PDFsDev folder with test PDFs
    /// When false, uses production PDFs folder with all books
    /// ⚠️ SET TO FALSE FOR PRODUCTION RELEASE
    var isDevelopmentMode: Bool = true
    
    /// 🚧 DEVELOPMENT MODE: List of book names that exist in PDFsDev folder
    /// Update this list to match the exact PDF files you have in PDFsDev
    /// These should match the "name" field of books in BookData.swift
    var devModeBookNames: [String] = [
        "Darshan Stuti (Ati Punya Uday Mam Aaya)",
        "Darshan Stuti (Sakal Gyey Gyayak Tadapi)"
    ]
    
    /// Returns the appropriate folder name based on development mode
    var s3FolderName: String {
        return isDevelopmentMode ? "PDFsDev" : "PDFs"
    }
    
    /// Maximum number of retry attempts for failed downloads
    var maxRetries: Int = 3
    
    /// Timeout interval for download requests (in seconds)
    var requestTimeout: TimeInterval = 60.0
    
    // MARK: - Private Properties
    
    private let urlSession: URLSession
    
    // MARK: - Initialization
    
    private init() {
        // Configure URLSession with appropriate timeout and caching policy
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 300.0 // 5 minutes for large files
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil // Disable caching for downloads
        
        self.urlSession = URLSession(configuration: configuration)
    }
    
    // MARK: - URL Construction
    
    /// Builds a direct S3 URL for a given S3 key
    /// 
    /// - Parameter s3Key: The S3 key (e.g., "PDFs/BookName.pdf")
    /// - Returns: The complete S3 URL, or nil if configuration is invalid
    func buildS3URL(for s3Key: String) -> URL? {
        guard let baseURL = s3BaseURL else {
            print("⚠️ S3 base URL not configured. Set S3Service.shared.s3BaseURL")
            return nil
        }
        
        // URL encode the S3 key to handle special characters
        guard let encodedKey = s3Key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        
        // Construct full URL: baseURL/PDFs/BookName.pdf
        let fullURLString = "\(baseURL)/\(encodedKey)"
        return URL(string: fullURLString)
    }
    
    /// Builds a direct S3 URL for a book's PDF
    /// 
    /// - Parameter book: The book to get the S3 URL for
    /// - Returns: The complete S3 URL, or nil if configuration is invalid
    func buildS3URL(for book: Book) -> URL? {
        let s3Key = book.s3Key()
        return buildS3URL(for: s3Key)
    }
    
    // MARK: - Download Methods
    
    /// Downloads a PDF from S3
    /// 
    /// - Parameters:
    ///   - s3URL: The direct S3 URL for the PDF
    ///   - destinationURL: The local file URL where the PDF should be saved
    ///   - progressHandler: Optional closure to track download progress (0.0 to 1.0)
    ///   - completion: Completion handler with success/failure result
    /// - Returns: The URLSessionDownloadTask for potential cancellation
    @discardableResult
    func downloadPDF(
        from s3URL: URL,
        to destinationURL: URL,
        progressHandler: ((Double) -> Void)? = nil,
        completion: @escaping (Result<URL, S3ServiceError>) -> Void
    ) -> URLSessionDownloadTask {
        return downloadPDF(
            from: s3URL,
            to: destinationURL,
            retryCount: 0,
            progressHandler: progressHandler,
            completion: completion
        )
    }
    
    /// Internal download method with retry logic
    private func downloadPDF(
        from s3URL: URL,
        to destinationURL: URL,
        retryCount: Int,
        progressHandler: ((Double) -> Void)?,
        completion: @escaping (Result<URL, S3ServiceError>) -> Void
    ) -> URLSessionDownloadTask {
        
        var request = URLRequest(url: s3URL)
        request.timeoutInterval = requestTimeout
        
        let task = urlSession.downloadTask(with: request) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            
            // Handle errors
            if let error = error {
                // Check if we should retry
                if retryCount < self.maxRetries {
                    print("⚠️ Download failed, retrying (\(retryCount + 1)/\(self.maxRetries)): \(error.localizedDescription)")
                    DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + Double(retryCount + 1)) {
                        _ = self.downloadPDF(
                            from: s3URL,
                            to: destinationURL,
                            retryCount: retryCount + 1,
                            progressHandler: progressHandler,
                            completion: completion
                        )
                    }
                    return
                } else {
                    completion(.failure(.networkError(error)))
                    return
                }
            }
            
            // Handle HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    if retryCount < self.maxRetries {
                        print("⚠️ HTTP error \(httpResponse.statusCode), retrying (\(retryCount + 1)/\(self.maxRetries))")
                        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + Double(retryCount + 1)) {
                            _ = self.downloadPDF(
                                from: s3URL,
                                to: destinationURL,
                                retryCount: retryCount + 1,
                                progressHandler: progressHandler,
                                completion: completion
                            )
                        }
                        return
                    } else {
                        completion(.failure(.httpError(httpResponse.statusCode)))
                        return
                    }
                }
            }
            
            // Handle missing temporary file
            guard let tempURL = tempURL else {
                completion(.failure(.noData))
                return
            }
            
            // Move file to destination
            do {
                // Remove existing file if it exists
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                
                // Ensure destination directory exists
                let destinationDir = destinationURL.deletingLastPathComponent()
                try FileManager.default.createDirectory(
                    at: destinationDir,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                
                // Move temporary file to final destination
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                
                print("✅ Successfully downloaded PDF to: \(destinationURL.path)")
                completion(.success(destinationURL))
                
            } catch {
                completion(.failure(.networkError(error)))
            }
        }
        
        // Set up progress tracking if handler is provided
        if let progressHandler = progressHandler {
            _ = task.progress.observe(\.fractionCompleted) { progress, _ in
                DispatchQueue.main.async {
                    progressHandler(progress.fractionCompleted)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    /// Downloads a PDF for a given book
    /// 
    /// - Parameters:
    ///   - book: The book to download
    ///   - progressHandler: Optional closure to track download progress
    ///   - completion: Completion handler with success/failure result
    /// - Returns: The URLSessionDownloadTask for potential cancellation
    @discardableResult
    func downloadPDF(
        for book: Book,
        progressHandler: ((Double) -> Void)? = nil,
        completion: @escaping (Result<URL, S3ServiceError>) -> Void
    ) -> URLSessionDownloadTask? {
        guard let s3URL = buildS3URL(for: book) else {
            completion(.failure(.invalidConfiguration))
            return nil
        }
        
        let destinationURL = PDFStorageManager.shared.localFileURL(for: book)
        
        return downloadPDF(
            from: s3URL,
            to: destinationURL,
            progressHandler: progressHandler,
            completion: completion
        )
    }
    
    // MARK: - Streaming Support
    
    /// Streams a PDF for on-demand viewing (checks local first, then streams from S3)
    /// 
    /// This is the easiest method for on-demand viewing:
    /// 1. Checks if PDF exists locally, uses that if available
    /// 2. Otherwise, streams from S3 using direct URL
    /// 
    /// - Parameters:
    ///   - book: The book to view
    ///   - completion: Completion handler with PDF data or error
    func streamPDFForViewing(
        for book: Book,
        completion: @escaping (Result<Data, S3ServiceError>) -> Void
    ) {
        // First, check if PDF exists locally
        let localURL = PDFStorageManager.shared.localFileURL(for: book)
        
        if FileManager.default.fileExists(atPath: localURL.path) {
            // Load from local storage
            do {
                let data = try Data(contentsOf: localURL)
                completion(.success(data))
            } catch {
                completion(.failure(.networkError(error)))
            }
            return
        }
        
        // Not local, stream from S3
        guard let s3URL = buildS3URL(for: book) else {
            completion(.failure(.invalidConfiguration))
            return
        }
        
        streamPDF(from: s3URL, completion: completion)
    }
    
    /// Streams a PDF from an S3 URL for on-demand viewing
    /// 
    /// - Parameters:
    ///   - s3URL: The direct S3 URL for the PDF
    ///   - completion: Completion handler with PDF data or error
    func streamPDF(
        from s3URL: URL,
        completion: @escaping (Result<Data, S3ServiceError>) -> Void
    ) {
        var request = URLRequest(url: s3URL)
        request.timeoutInterval = requestTimeout
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
