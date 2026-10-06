//
//  IGTextField.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import SwiftUI

struct IGTextField<E: Error>: View {
    @Binding private var text: String
    @Binding private var error: E?
    
    private let isLoading: Bool
    private let placeholder: String
    
    init(_ placeholder: String, text: Binding<String>) where E == Never {
        self.placeholder = placeholder
        self.isLoading = false
        
        _text = text
        _error = .constant(nil)
    }
    
    init(_ placeholder: String, text: Binding<String>, error: Binding<E?>, isLoading: Bool) {
        self.placeholder = placeholder
        self.isLoading = isLoading
        
        _text = text
        _error = error
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                TextField(placeholder, text: $text)
                    .font(.subheadline)
                    .padding(12)
                    .frame(width: 360, height: 48)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                if isLoading {
                    ProgressView()
                        .padding(.trailing)
                }
                
                if error != nil {
                    Button {
                        text = ""
                        error = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .padding(.trailing)
                    }

                }
            }
            
            if let error {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    Group {
        IGTextField("Email", text: .constant(""))
            .padding(.bottom, 24)
        
        IGTextField(
            "Loading",
            text: .constant(""),
            error: .constant(AuthenticationError.invalidCredential),
            isLoading: true)
        .padding(.bottom, 24)
        
        IGTextField(
            "Email",
            text: .constant(""),
            error: .constant(NSError(domain: "", code: -1)),
            isLoading: false)
        .padding(.bottom, 24)
    }
}
