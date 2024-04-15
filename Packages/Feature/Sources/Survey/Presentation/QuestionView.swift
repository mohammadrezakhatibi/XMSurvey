//
//  SwiftUIView.swift
//  
//
//  Created by Mohammadreza Khatibi on 16.04.24.
//

import SwiftUI

struct QuestionView: View {
    @State var answer: String = ""
    var body: some View {
        ScrollView {
            VStack {
                Text("Question")
                    .font(.title2)
                    .bold()
                    .padding(.vertical, 0)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.secondary.opacity(0.15))
                    TextEditor(text: $answer)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .foregroundStyle(.primary)
                }
                .frame(height: 150)
            }
            .padding(.horizontal, 16)
            
            Button {
                
                
            } label: {
                HStack {
                    Text("Submit")
                        
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
            
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    QuestionView()
}
