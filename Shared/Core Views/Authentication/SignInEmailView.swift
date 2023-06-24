//
//  SignInEmailView.swift
//  language learning app
//
//  Created by Larissa Troper on 2023-06-15.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
        
            Button{
                Task{
                    do{
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("Error \(error)")
                    }
                    
                    do{
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print("Error \(error)")
                    }
                }
            } label: {
                Text("Sign In With Email")
                   .font(.headline)
                   .foregroundColor(.white)
                   .frame(height: 55)
                   .frame(maxWidth: .infinity)
                   .background(Color.blue)
                   .cornerRadius(10)
            }
            
            Spacer()
            
        }.padding()
        .navigationTitle("Sign In With Email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView(showSignInView: .constant(false))
    }
}
