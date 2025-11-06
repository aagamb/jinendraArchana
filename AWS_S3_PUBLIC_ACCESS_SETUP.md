# AWS S3 Public Access Setup Guide

## Overview

To allow your app to directly access PDFs from S3 without pre-signed URLs, you need to configure your S3 bucket for public read access.

## Step 1: Configure Block Public Access Settings

Based on your current S3 bucket settings, you need to **disable public access blocking**:

### In the AWS S3 Console:

1. **Go to your bucket** → Click on the **"Permissions"** tab
2. **Scroll to "Block public access (bucket settings)"**
3. **Click "Edit"** button (top right)
4. **Turn OFF "Block all public access"** (set it to "Off")
5. **Uncheck all 4 individual settings:**
   - ❌ Block public access to buckets and objects granted through *new* access control lists (ACLs)
   - ❌ Block public access to buckets and objects granted through *any* access control lists (ACLs)
   - ❌ Block public access to buckets and objects granted through *new* public bucket or access point policies
   - ❌ Block public and cross-account access to buckets and objects through *any* public bucket or access point policies
6. **Click "Save changes"**
7. **Confirm** by typing "confirm" in the dialog

## Step 2: Configure Bucket Policy

After disabling public access blocking, you need to add a bucket policy to actually allow public read access:

1. **Still in the "Permissions" tab**, scroll to **"Bucket policy"**
2. **Click "Edit"** → **"Policy"**
3. **Paste this policy** (replace `YOUR_BUCKET_NAME` with your actual bucket name):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*"
        }
    ]
}
```

4. **Click "Save changes"**

## Step 3: Verify Your S3 Base URL

Your S3 base URL format depends on your bucket region:

- **Format 1 (Path-style)**: `https://s3.REGION.amazonaws.com/BUCKET_NAME`
- **Format 2 (Virtual-hosted-style)**: `https://BUCKET_NAME.s3.REGION.amazonaws.com`
- **Format 3 (Virtual-hosted-style, older)**: `https://BUCKET_NAME.s3-REGION.amazonaws.com`

### Examples:
- US East (N. Virginia): `https://jinendra-archana-pdfs.s3.us-east-1.amazonaws.com`
- US West (Oregon): `https://jinendra-archana-pdfs.s3.us-west-2.amazonaws.com`
- EU (Ireland): `https://jinendra-archana-pdfs.s3.eu-west-1.amazonaws.com`

### How to Find Your URL:
1. Go to your S3 bucket
2. Click on any PDF file
3. Look at the "Object URL" - it will show the full URL format
4. Remove the file name and path to get the base URL

For example, if the Object URL is:
```
https://jinendra-archana-pdfs.s3.us-east-1.amazonaws.com/PDFs/Jinpoojan%20Rahasya.pdf
```

Your base URL should be:
```
https://jinendra-archana-pdfs.s3.us-east-1.amazonaws.com
```

## Step 4: Configure in Your App

In your app initialization (e.g., `JinendraArchanaApp.swift` or `ContentView.swift`):

```swift
// Set your S3 base URL
S3Service.shared.s3BaseURL = "https://your-bucket-name.s3.region.amazonaws.com"
```

## Security Considerations

⚠️ **Important Notes:**
- Public read access means anyone with the URL can access your PDFs
- This is fine for public content (like religious texts)
- Consider using CloudFront with signed URLs if you need more security
- Monitor your S3 usage to prevent abuse

## Testing

After configuration, test by:
1. Opening a PDF directly in your browser using the full S3 URL
2. If it downloads, public access is working
3. If you get "Access Denied", check your bucket policy and block public access settings

## Troubleshooting

### "Access Denied" Errors:
- Verify block public access is OFF (all 4 settings unchecked)
- Verify bucket policy is correct and saved
- Check that the bucket name in the policy matches exactly
- Wait a few minutes for changes to propagate

### "Invalid URL" Errors:
- Verify your S3 base URL format is correct
- Check that the region is correct
- Ensure no trailing slashes in the base URL

### Files Not Found:
- Verify PDFs are uploaded to the `PDFs/` folder in your bucket
- Check that file names match exactly (spaces, special characters)
- URLs are automatically URL-encoded, but verify the file names in S3 match your `Book.name` values

