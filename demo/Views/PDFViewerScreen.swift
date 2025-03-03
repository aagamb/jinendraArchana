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
    
    var body: some View {
        ZStack(alignment: .top) {
            PDFViewer(pdfName: pdfName, isNavBarHidden: $isNavBarHidden)
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
                //enable swiping to go to the previous screen
                .gesture(DragGesture()
                    .onEnded { value in
                        if value.translation.width>100 {
                            dismiss()
                        }
                    }
                )
            
            if !isNavBarHidden {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            Text("Back")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 5)
                        .padding(.leading,20)
                        .padding(.bottom, 20)
                        Spacer()
                        
                    }
                    .background(Color.white)
                }
                .frame(maxWidth: .infinity)
                .background(Color.clear)
            }
        }
        .toolbar(.hidden , for: .tabBar, .navigationBar)
        .animation(.easeInOut(duration: 0.5), value: isNavBarHidden)
        //        .toolbar(isNavBarHidden ? .hidden: .visible, for: .navigationBar)
        
        
    }
}

#Preview {
    ContentView()
}

