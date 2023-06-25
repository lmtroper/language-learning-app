//
//  AuthenticationViewModel.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject{
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
}
