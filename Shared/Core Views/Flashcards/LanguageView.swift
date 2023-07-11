//
//  FlashcardView.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import SwiftUI
import UIKit

@MainActor
final class FlashcardViewModel: ObservableObject {
    
    func addFlashcard(term:String, answer:String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFlashcard(userId: authDataResult.uid, flashcardId: "", term: term, answer: answer, isActive: true, status: true)
        }
    }
    
    func addFlashcardCollection(language:String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addFlashcardCollection(userId: authDataResult.uid, language: language)
        }
    }
    
    func getFlashcardCollections(){
        Task {
            print("getting flashcards")
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.getFlashcardCollections(userId: authDataResult.uid)
        }
    }
    
}

struct LanguageView: View {
    
    @StateObject private var viewModel = FlashcardViewModel()
    @Binding var showSignInView: Bool
    @State private var term: String = ""
    @State private var answer: String = ""
    
    let flashcardCollections: [String] = ["Spanish", "French", "German", "Polish", "English"]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                    ForEach(0..<((flashcardCollections.count + 1) / 2)) { row in
                        if row * 2 < flashcardCollections.count {
                            CardView(note: flashcardCollections[row * 2])
                        } else {
                            Color.clear
                        }
                        
                        if row * 2 + 1 < flashcardCollections.count {
                            CardView(note: flashcardCollections[row * 2 + 1])
                        } else {
                            Color.clear
                        }
                    }
                }
                
            
                
                .padding(15)
            }
            Button {
                viewModel.getFlashcardCollections()
            } label: {
                Text("Add Collection")
            }

            Spacer()
        }
        .navigationTitle("Flashcards")
        
    }
}

struct CardView: View {
    
    let note: String

    private let colorMapping: [String: Color] = [
        "Spanish": .blue,
        "French": .red,
        "German": .green,
        "Polish": .orange,
        "English": .purple
    ]

    var body: some View {
        VStack {
            Button(action: {
            }) {
                NavigationLink(destination: FlashcardCollectionView(showSignInView: .constant(false), selectedLanguage: .constant(note))) {
                    Text(note)
                        .font(.body)
                        .frame(width: 135, height: 150)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .padding()
                        .background(backgroundColor)
                        .cornerRadius(10)
                }
            }
        }
        .background(Color.gray)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(10)
    
    }
    
    var backgroundColor: Color {
        colorMapping[note] ?? .gray
    }
}

struct LanguageView_Previews: PreviewProvider {
    @State static private var selectedLanguage: String = ""
    
    static var previews: some View {
        NavigationView {
            LanguageView(showSignInView: .constant(false))
        }
    }
}
