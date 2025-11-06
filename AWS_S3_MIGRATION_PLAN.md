# AWS S3 Migration Plan: PDF Cloud Storage Implementation

## Overview
This document outlines the plan to migrate PDF files from app bundle to AWS S3, enabling smaller app size and flexible access patterns (offline packs vs on-demand loading).

## Current Architecture
- **PDF Location**: Bundled in app at `Bundle.main.resourceURL/PDFs/`
- **PDF Count**: ~223 PDF files
- **Access Pattern**: Direct file access via `PDFViewer.swift`
- **Book Data**: Defined in `BookData.swift` with sections (Stavan, Poojan, Adhyatmik Path, Bhakti)

## Target Architecture

### 1. AWS S3 Setup
- **Bucket**: Create S3 bucket with intelligent tiering enabled
- **Structure**: Flat structure (e.g., `s3://bucket-name/PDFs/{Book.name}.pdf`)
- **Naming**: Keep filename mapping: `{Book.name}.pdf` → S3 key
- **Access**: Public read access (or presigned URLs if security needed)
- **CDN**: Optional CloudFront distribution for faster downloads

### 2. App Components to Build

#### A. PDF Download Manager (`PDFDownloadManager.swift`)
- **Responsibilities**:
  - Download PDFs from S3
  - Manage download queue (sequential/parallel)
  - Track download progress
  - Handle resume on interruption
  - Store downloaded PDFs in app's Documents directory
  - Verify downloads with checksums

#### B. Local Storage Manager (`PDFStorageManager.swift`)
- **Responsibilities**:
  - Check if PDF exists locally
  - Return local file path if available
  - Generate S3 URL for remote PDFs
  - Manage local cache directory
  - Handle storage cleanup (optional)

#### C. PDF Pack Manager (`PDFPackManager.swift`)
- **Responsibilities**:
  - Download all PDFs as one complete pack
  - Track overall download status (all downloaded or not)
  - Calculate total size and count of all PDFs
  - Manage download of entire PDF collection

#### D. Network Service (`S3Service.swift`)
- **Responsibilities**:
  - Build S3 URLs
  - Handle HTTP requests to S3
  - Support streaming for on-demand loading
  - Error handling and retry logic

#### E. Updated PDF Viewer (`PDFViewer.swift` enhancement)
- **Changes**:
  - Check local storage first
  - If not local, load from S3 URL
  - Show loading indicator for remote PDFs
  - Handle offline scenarios gracefully

#### F. Settings UI (`DownloadSettingsView.swift`)
- **Features**:
  - Toggle between "Offline Mode" (all PDFs downloaded) and "Online Mode" (on-demand)
  - Show download status: "All PDFs Downloaded" or "Download All PDFs" button
  - Delete all downloaded PDFs option
  - View storage usage
  - Show total PDF count and size

#### G. Download Progress UI (`DownloadProgressView.swift`)
- **Features**:
  - Show overall download progress (X of Y PDFs downloaded)
  - Show total progress percentage
  - Show individual PDF download status (optional detail view)
  - Pause/resume downloads
  - Cancel download

## Implementation Steps

### Phase 1: Infrastructure Setup

#### Step 1.1: AWS S3 Bucket Setup
1. Create S3 bucket (e.g., `jinendra-archana-pdfs`)
2. Enable intelligent tiering
3. Upload all PDFs to flat structure (`PDFs/{Book.name}.pdf`)
4. Set bucket policy for public read (or configure CloudFront)
5. Document S3 base URL structure

#### Step 1.2: Update BookData Model
- Add helper to generate S3 URLs from book name
- Create helper function to get all books for download
- No structural changes needed to Book model

#### Step 1.3: Create Local Storage Structure
- Use `FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)`
- Create `PDFs/` subdirectory
- Maintain same filename structure for easy lookup

### Phase 2: Core Services

#### Step 2.1: Create S3Service
- Implement URL construction
- Add URLSession for downloading
- Handle errors and retries
- Support streaming for on-demand viewing

#### Step 2.2: Create PDFStorageManager
- Implement local file checking
- Implement file saving
- Implement cache management
- Add file size tracking

#### Step 2.3: Create PDFDownloadManager
- Implement download queue
- Add progress tracking (Combine or async/await)
- Handle resume capability
- Store downloads to Documents directory

### Phase 3: PDF Pack System

#### Step 3.1: Create PDFPackManager
- Implement "download all" functionality
- Calculate total size of all PDFs
- Track download status (not downloaded, downloading, downloaded, partially downloaded)
- Get count of all PDFs from BookData
- Show overall progress (X of Y PDFs downloaded)

### Phase 4: UI Updates

#### Step 4.1: Update PDFViewer
- Modify to check local storage first
- Load from S3 if not local
- Add loading state UI
- Handle errors gracefully

#### Step 4.2: Create Download Settings View
- Add to SettingsPanel 
- Show "Download All PDFs" button (if not all downloaded). when pressed, a notificiation should come confirming that you want to, then download. 
- If all PDFs are downloaded, show a button to delete all PDFs, and show a notificatoin when pressed confirming that you want to see everything in the cloud
- Display storage usage
- Show total PDF count and download progress

#### Step 4.3: Create Download Progress View
- Show active downloads
- Display progress bars
- Add pause/resume/cancel buttons

#### Step 4.4: Update BookListView
- Add download indicator (✓ for downloaded, cloud for remote)
- Show loading state when fetching remote PDF
- Handle offline scenarios

### Phase 5: User Experience Enhancements

#### Step 5.1: On-Demand Loading
- When user clicks PDF not downloaded:
  - Show loading indicator
  - Stream PDF from S3
  - Option to save for offline (button in viewer)

#### Step 5.2: Offline Pack Downloads
- In settings, show "Download All PDFs" option
- User taps button → downloads all PDFs
- Show progress for entire download (X of Y PDFs, percentage)
- Notify when all downloads complete
- Option to pause/resume/cancel

#### Step 5.3: Smart Defaults
- On first launch, prompt user: "Download all PDFs for offline access?" or "Load PDFs on-demand?"
- Store preference in UserDefaults
- Allow changing preference in settings
- Remember user's choice for future launches

### Phase 6: Testing & Optimization

#### Step 6.1: Testing
- Test offline mode (all PDFs downloaded)
- Test online mode (on-demand loading)
- Test partial download state (some downloaded, some not)
- Test "download all" functionality
- Test network interruption handling during bulk download
- Test storage management and cleanup

#### Step 6.2: Optimization
- Implement PDF caching strategy
- Add background download support for bulk downloads
- Optimize download order (can be sequential or parallel with limits)
- Add compression if needed
- Consider prioritization of frequently accessed PDFs

## Technical Considerations

### 1. S3 URL Structure
```
Base URL: https://your-bucket.s3.region.amazonaws.com/PDFs/
Full URL: https://your-bucket.s3.region.amazonaws.com/PDFs/Jinpoojan%20Rahasya.pdf
```
(Note: Flat structure, no section folders)

### 2. Local Storage Path
```
Documents/PDFs/{Book.name}.pdf
```

### 3. Configuration
- Store S3 base URL in app configuration (could be in Info.plist or remote config)
- Consider using environment variables for different builds (dev/staging/prod)

### 4. Error Handling
- Network errors (no internet, timeouts)
- S3 errors (404, 403)
- Storage errors (disk full)
- Invalid PDF errors

### 5. Security
- If using presigned URLs, implement URL generation service
- Consider CloudFront signed URLs for additional security
- Validate downloaded PDF integrity (optional checksums)

### 6. Performance
- Use background URLSession for downloads
- Implement download prioritization
- Cache frequently accessed PDFs
- Consider PDF thumbnail generation

### 7. User Preferences
- Store in UserDefaults:
  - `preferredDownloadMode`: "offline" | "online"
  - `allPDFsDownloaded`: Boolean indicating if all PDFs are downloaded
  - `downloadedPDFs`: Set of PDF names (for tracking partial downloads)
  - `downloadProgress`: Current download progress (0.0 to 1.0)

## Migration Strategy

### Step 1: Dual Mode Support
- Keep bundled PDFs initially
- Add S3 support alongside
- Allow gradual migration

### Step 2: Remove Bundle PDFs
- After validating S3 setup works
- Remove PDFs from Xcode project
- Update build settings

### Step 3: Update App Store Listing
- Update app size in listing
- Note in description about offline download option

## File Structure Preview

```
Jinendra Archana/
├── Models/
│   ├── BookData.swift (updated)
│   └── DownloadStatus.swift (new)
├── Services/
│   ├── S3Service.swift (new)
│   ├── PDFStorageManager.swift (new)
│   ├── PDFDownloadManager.swift (new)
│   └── PDFPackManager.swift (new)
├── Views/
│   ├── DownloadSettingsView.swift (new)
│   └── DownloadProgressView.swift (new)
└── UIViewRepresentable/
    └── PDFViewer.swift (updated)
```

## Estimated Development Time
- Phase 1: 2-3 hours (AWS setup + planning)
- Phase 2: 4-6 hours (Core services)
- Phase 3: 2-3 hours (Single pack system - simplified)
- Phase 4: 3-5 hours (UI updates - simplified)
- Phase 5: 2-3 hours (UX enhancements)
- Phase 6: 3-4 hours (Testing & optimization)

**Total: ~16-24 hours** (slightly reduced due to simplified pack structure)

## Next Steps
1. Review and approve this plan
2. Set up AWS S3 bucket
3. Upload PDFs to S3
4. Begin Phase 2 implementation

