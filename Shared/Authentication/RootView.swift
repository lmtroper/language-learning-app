//
//  RootView.swift
//  language learning app
//
//  Created by Larissa Troper on 2023-06-15.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        
        ZStack{
            if !showSignInView{
                NavigationView{
                    SettingsView(showSignInView:  $showSignInView)
                }
            }
            
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationView{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
