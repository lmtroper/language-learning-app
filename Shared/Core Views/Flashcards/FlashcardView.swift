//
//  FlashcardView.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import SwiftUI

@MainActor
final class FlashcardViewModel: ObservableObject {
    
    func addFlashcard(term:String, answer:String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFlashcard(userId: authDataResult.uid, flashcardId: "", term: term, answer: answer, isActive: true, status: true)
        }
    }
    
}

struct FlashcardView: View {
    
    @StateObject private var viewModel = FlashcardViewModel()
    @Binding var showSignInView: Bool
    @State private var term: String = ""
    @State private var answer: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter term", text: $term)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter answer", text: $answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button {
                viewModel.addFlashcard(term: term, answer: answer)
            } label: {
                Text("Add Flashcard")
            }
            
            Spacer()
        }
        .navigationTitle("Flashcards")
        
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlashcardView(showSignInView: .constant(false))
        }
    }
}
