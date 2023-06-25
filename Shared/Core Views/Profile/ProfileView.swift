//
//  ProfileView.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func addUserLanguage(text: String) {
        guard let user else {return}
        Task {
            try await UserManager.shared.addUserLanguage(userId: user.userId, language: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeUserLanguage(text: String) {
        guard let user else {return}
        Task {
            try await UserManager.shared.removeUserLanguage(userId: user.userId, language: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let languageOptions: [String] = ["English", "French", "Spanish", "Polish", "Italian"]
    
    private func languageIsSelected(text: String) -> Bool {
        viewModel.user?.languages?.contains(text) == true
    }
    
    var body: some View {
        List{
            if let user = viewModel.user{
                Text("UserId: \(user.userId)")
                
                if let email = user.email {
                    Text("Email: \(email)")
                }
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                VStack {
                    HStack{
                        ForEach(languageOptions, id: \.self) { language in
                            Button(language) {
                                if languageIsSelected(text: language) {
                                    viewModel.removeUserLanguage(text: language)
                                } else {
                                    viewModel.addUserLanguage(text: language)
                                }
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(languageIsSelected(text: language) ? .green : .red)
                        }
                        
                    }
                    Text("User Languages: \((user.languages ?? []).joined(separator: ", "))").frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                NavigationLink{
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(showSignInView: .constant(false))
        }
    }
}
