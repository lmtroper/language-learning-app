//
//  SettingsViewModel.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOptions] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
                                               
    func signOut () throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword () async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail () async throws {
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
        let email = "hello@test.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword () async throws {
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
        let password = "hello123@"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func deleteAccount() async throws{
        try await AuthenticationManager.shared.delete()
    }
}
