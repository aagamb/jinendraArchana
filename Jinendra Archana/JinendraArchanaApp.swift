//
//  JinendraArchanaApp.swift
//  Jinendra Archana
//
//  Created by Aagam Bakliwal on 2/24/25.
//

import SwiftUI

@main
struct JinendraArchanaApp: App {
    
    init() {
        // Initialize PDFStorageManager to ensure PDFs directory is created
        // This ensures the local storage structure is ready for Step 1.3
        _ = PDFStorageManager.shared
        
        // Configure S3 base URL (without trailing /PDFs/ since s3Key() includes it)
        S3Service.shared.s3BaseURL = "https://jinendra-archana.s3.us-east-2.amazonaws.com"
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
