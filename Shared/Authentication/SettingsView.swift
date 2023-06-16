//
//  SettingsView.swift
//  language learning app
//
//  Created by Larissa Troper on 2023-06-15.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
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
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List{
            Button("Log Out"){
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
                
            }
            emailSection
        }.navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section{
            Button("Reset Password"){
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET")
                    } catch {
                        print(error)
                    }
                }
                
            }
            Button("Update Password"){
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("UPDATE PASSWORD")
                    } catch {
                        print(error)
                    }
                }
                
            }
            Button("Update Email"){
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("UPDATE EMAIL")
                    } catch {
                        print(error)
                    }
                }
                
            }
            
        } header: {
            Text("Email and Password Functions")
        }
    }
}
