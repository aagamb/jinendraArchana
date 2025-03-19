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
    @State private var feedbackText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                List {
                    
                    Section(header: Text("Name")) {
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                            
                            TextEditor(text: $nameText)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 40, maxHeight:60)
                                .autocorrectionDisabled()
                                .onSubmit() {
                                    nameText = ""
                                }
                            
                            //placeholder text
                            if nameText.isEmpty {
                                Text("Enter your name...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 6)
                            }
                        }
                    }
                    
                    Section(header: Text("Any Changes/Modifications/Broken Features")) {
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                            TextEditor(text: $feedbackText)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 40, maxHeight:450)
                                .autocorrectionDisabled()
                                .onSubmit() {
                                    feedbackText = ""
                                }
                            
                            //placeholder text
                            if feedbackText.isEmpty {
                                Text("Enter your feedback here...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 6)
                            }
                        }
                        if !feedbackText.isEmpty || !nameText.isEmpty {
                            HStack{
                                
                                Button(action: {
                                    
                                }) {
                                    Text("Clear")
                                        .foregroundStyle(.red)
                                        .padding(.leading)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    feedbackSubmitButtonAction()
                                }) {
                                    Text("Submit")
                                        .foregroundStyle(
                                            feedbackText.isEmpty || nameText.isEmpty ? .gray : .blue
                                        )
                                        .padding(.trailing)
                                }
                                .disabled(feedbackText.isEmpty || nameText.isEmpty)
                            }
                        }
                    }
                    
                    
                }
                
                
            }
            .navigationTitle("Feedback")
            .navigationBarItems(trailing: Button("Done") { hideKeyboard() })
        }
        
    }
    
    
    private func feedbackSubmitButtonAction() {
        guard let url = URL(string: "https://feedback-api-e50o.onrender.com/feedback") else {
            print("Invalid URL")
            return
        }
        
        let feedbackData: [String: Any] = [
            "name": nameText,
            "message": feedbackText,
            "category": "general" // Modify if you have dynamic categories
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: feedbackData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error submitting feedback: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }
                
                // Clear only after request completes successfully
                DispatchQueue.main.async {
                    nameText = ""
                    feedbackText = ""
                }
            }.resume()
            
        } catch {
            print("Failed to encode JSON: \(error.localizedDescription)")
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

