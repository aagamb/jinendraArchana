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
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader{geometry in
                PDFViewer(pdfName: pdfName, isNavBarHidden: $isNavBarHidden, orientation: $orientation)
                    .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
                    .onTapGesture {
                        isNavBarHidden.toggle()
                    }
                    .onAppear {
                        isTabViewHidden = true
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
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.4), value: isReadingModeOn)
                    .allowsHitTesting(false)
            }
            
            
            
            if !isNavBarHidden {
                if fabSelected {
                    floatingActionButtons()
                } else {
                    floatingActionButton()   // the bottom-right scrolling button
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(isNavBarHidden)
        .animation(.easeInOut(duration: 0.5), value: isNavBarHidden)
        
        
    }
    
    
    private func floatingActionButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    fabSelected.toggle()
                }) {
                    Image(systemName: "plus")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .padding(.trailing, 40)
                        .padding(.bottom, 8)
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
                }
                
                Button(action: {
                    isReadingModeOn.toggle()
                }) {
                    Image(systemName: "book.closed.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .padding(.trailing, 40)
                        .padding(.bottom, 8)
                }
                
            }
            
            HStack {
                Spacer()
                Button(action: {
                    fabSelected.toggle()
                }) {
                    Image(systemName: "plus")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .padding(.trailing, 40)
                        .padding(.bottom, 8)
                }
            }
        }
    }
}




#Preview {
    PDFViewerScreen(pdfName: "Vinay Path", isTabViewHidden: .constant(true))
}

