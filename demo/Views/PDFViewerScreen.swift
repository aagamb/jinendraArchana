//
//  PDFViewerScreen.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/27/25.
//

import Foundation
import SwiftUI

struct PDFViewerScreen: View {
    let pdfName: String
    @State private var isNavBarHidden = false
    @Binding var isTabViewHidden: Bool
    
    var body: some View {
        ZStack {
            PDFViewer(pdfName: pdfName, isNavBarHidden: $isNavBarHidden)
                .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)){
                        isNavBarHidden.toggle()
                    }
                }
                .onAppear {
                    isTabViewHidden = true
                }
                .onDisappear {
                    isTabViewHidden = false
                }
        }
        .navigationBarHidden(isNavBarHidden)
        .toolbar(isTabViewHidden ? .hidden : .visible, for: .tabBar)
        
    }
}

