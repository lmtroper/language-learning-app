//
//  SettingsView.swift
//  language learning app
//
//  Created by Larissa Troper on 2023-06-15.
//

import SwiftUI

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
            
            Button(role: .destructive){
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete Account")
            }
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
        }.onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
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
