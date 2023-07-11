//
//  TabbarView.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView{
            NavigationView {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            NavigationView {
                LanguageView(showSignInView: $showSignInView)

            }
            .tabItem {
                Image(systemName: "scribble")
                Text("Flashcards")
                
            }
        }
        .accentColor(Color.orange)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(showSignInView: .constant(false))
    }
}
