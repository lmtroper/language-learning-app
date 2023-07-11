//
//  FlashcardCollectionView.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-07-10.
//

import SwiftUI

@MainActor
final class FlashcardCollectionViewModel: ObservableObject {
    
}

struct FlashcardCollectionView: View {
    
    @StateObject private var viewModel = FlashcardCollectionViewModel()
    @Binding var showSignInView: Bool
    @Binding var selectedLanguage: String

    
    var body: some View {
        Text("selected language: " + selectedLanguage)
    }
}

//struct FlashcardCollectionView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        NavigationView {
//            FlashcardCollectionView( showSignInView: .constant(false), selectedLanguage: $selectedLanguage)
//        }
//    }
//}
