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
    @Environment(\.dismiss) private var dismiss
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State private var fabSelected = false
    @State private var isReadingModeOn = false
    @State private var readingModeOpacity: Double = 0.2
    
    // UserDefaults keys for persistent storage
    private let readingModeKey = "isReadingModeOn"
    private let readingModeOpacityKey = "readingModeOpacity"
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                PDFViewer(pdfName: pdfName, isNavBarHidden: $isNavBarHidden, orientation: $orientation)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        isNavBarHidden.toggle()
                    }
                    .onAppear {
                        isTabViewHidden = true
                        loadReadingModeState()
                    }
                    .onDisappear {
                        isTabViewHidden = false
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        orientation = UIDevice.current.orientation
                    }
                    .gesture(DragGesture()
                        .onEnded { value in
                            if value.translation.width>100 {
                                dismiss()
                            }
                        }
                    )
                
                Color.yellow
                    .opacity(isReadingModeOn ? readingModeOpacity : 0)
                    .ignoresSafeArea(.all)
                    .animation(.easeInOut(duration: 0.4), value: isReadingModeOn)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea(.all)
            
            
            
            if !isNavBarHidden {
                if fabSelected {
                    floatingActionButtons()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: isNavBarHidden)
                } else {
                    floatingActionButton()   // the bottom-right scrolling button
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: isNavBarHidden)
                }
            }
        }
        .ignoresSafeArea(.all)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(isNavBarHidden)
        .animation(.easeInOut(duration: 0.3), value: isNavBarHidden)
        .transition(.opacity)
        
        
    }
    
    // MARK: - Reading Mode Persistence Methods
    
    private func loadReadingModeState() {
        isReadingModeOn = UserDefaults.standard.bool(forKey: readingModeKey)
        readingModeOpacity = UserDefaults.standard.double(forKey: readingModeOpacityKey)
        // If no saved opacity value, use default
        if readingModeOpacity == 0.0 {
            readingModeOpacity = 0.2
        }
    }
    
    private func saveReadingModeState() {
        UserDefaults.standard.set(isReadingModeOn, forKey: readingModeKey)
        UserDefaults.standard.set(readingModeOpacity, forKey: readingModeOpacityKey)
    }
    
    private func floatingActionButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    fabSelected.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .padding(.trailing, 40)
                        .padding(.bottom, 60)
                }
            }
        }
    }
    
    private func floatingActionButtons() -> some View {
        VStack {
            
            Spacer()
            HStack {
                Spacer()
                if isReadingModeOn {
                    Slider(value: $readingModeOpacity, in: 0.05...0.3, step: 0.0001)
                        .frame(width: 250)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.8)))
                        .transition(.opacity)
                        .onChange(of: readingModeOpacity) {
                            saveReadingModeState()
                        }
                }
                
                Button(action: {
                    isReadingModeOn.toggle()
                    saveReadingModeState()
                }) {
                    Image(systemName: "book.closed.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(isReadingModeOn ? Color.green : Color.blue))
                        .padding(.trailing, 40)
                        .padding(.bottom, 8)
                }
                
            }
            
            HStack {
                Spacer()
                Button(action: {
                    fabSelected.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .padding(.trailing, 40)
                        .padding(.bottom, 60)
                }
            }
        }
    }
}




#Preview {
    PDFViewerScreen(pdfName: "Vinay Path", isTabViewHidden: .constant(true))
}

