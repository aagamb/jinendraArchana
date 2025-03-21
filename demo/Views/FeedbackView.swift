//
//  FeedbackView.swift
//  demo
//
//  Created by Aagam Bakliwal on 3/19/25.
//

import Foundation
import SwiftUI

struct FeedbackView: View {
    @State private var nameText: String = ""
    @State private var brokenText: String = ""
    @State private var requestedText: String = ""
    @State private var isFeedbackSubmitted: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                
                List {
                    
                    Section(header: Text("Jai Jinendra")) {
                        Text("Welcome, Beta Testers. This feedback section is exclusively available to you and will be removed before the final production release. We greatly appreciate your insights and feedback.")
                    }
                    
                    Section(header: Text("Name")) {
                        textEditorView(text: $nameText, placeholder: "Enter your name...")
                    }

                    Section(header: Text("Broken Features")) {
                        textEditorView(text: $brokenText, placeholder: "Please list features you have found broken")
                    }
                    
                    Section(header: Text("Modifications")) {
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                            textEditorView(text: $requestedText, placeholder: "Please list any features which you would like to see in the future")

                        }
                        
                        if !brokenText.isEmpty || !requestedText.isEmpty {
                            HStack{
                                
                                Button(action: {
                                    
                                }) {
                                    Text("Clear")
                                        .foregroundStyle(.red)
                                        .padding(.leading)
                                }
                                
                                Spacer()
                                
                                if isLoading {
                                    ProgressView()
                                        .padding(.trailing)
                                } else {
                                    Button(action: {
                                        feedbackSubmitButtonAction()
                                        
                                    }) {
                                        Text("Submit")
                                            .foregroundStyle(
                                                brokenText.isEmpty || nameText.isEmpty ? .gray : .blue
                                            )
                                            .padding(.trailing)
                                    }
                                    .disabled(nameText.isEmpty || brokenText.isEmpty || requestedText.isEmpty)
                                }
                                
                            }
                        }
                        
                        if isFeedbackSubmitted {
                            Text("Feedback Submitted")
                                .foregroundStyle(.green)
                                
                        }
                        
                    }
                }
                
                
            }
            .navigationTitle("Feedback")
            .navigationBarItems(trailing: Button("Done") { hideKeyboard() })
        }
        
    }
    
    
    private func feedbackSubmitButtonAction() {
        guard let url = URL(string: "https://feedback-api-e50o.onrender.com/feedback/") else {
            print("Invalid URL")
            return
        }
        
        let feedbackData: [String: Any] = [
            "name": nameText,
            "broken": brokenText,
            "requested": requestedText,
            "category": "general" // Modify if you have dynamic categories
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: feedbackData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            isLoading = true //start loading
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    isLoading = false //stop loading
                }
                
                if let error = error {
                    print("Error submitting feedback: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }
                
                // Clear only after request completes successfully
                DispatchQueue.main.async {
                    isFeedbackSubmitted = true
                    nameText = ""
                    brokenText = ""
                    requestedText = ""
                }

            }.resume()
            
        } catch {
            print("Failed to encode JSON: \(error.localizedDescription)")
        }
    }

    private func textEditorView(text: Binding<String>, placeholder: String) -> some View {
            ZStack(alignment: .topLeading) {
                TextEditor(text: text)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 40, maxHeight: 60)
                    .autocorrectionDisabled()

                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 6)
                        .allowsHitTesting(false)
                }
            }
        }
}

/// to allow the keyboard to be dismissed when done is pressed
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    FeedbackView()
}

