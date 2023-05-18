//
//  ContentView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/01.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    @EnvironmentObject var authManager: AuthManager
    @State var page: Int = 0
    @State var profile: Bool = false
    
    var body: some View {
        NavigationStack {
            TabView(selection: $page) {
                ZStack {
                    ProfileView()
                        .environmentObject(fireStoreManager)
                        .environmentObject(authManager)
                    if authManager.login == false && authManager.currentUser == nil {
                        Color.white
                        LoginView()
                    }
                }
                    .tabItem{
                        Label("", systemImage: "person.fill")
                    }
                ZStack {
                    ChattingView()
                        .environmentObject(fireStoreManager)
                        .environmentObject(authManager)
                    if authManager.login == false && authManager.currentUser == nil {
                        Color.white
                        LoginView()
                    }
                }
                .tabItem{
                    Label("chat", systemImage: "plus")
                }
            }
        }
        .toolbar {
            if authManager.login == true {
                NavigationLink(destination: ProfileView().environmentObject(authManager)) {
                    Image(systemName: "location.magnifyingglass")
                }
            }
            NavigationLink(destination: AddFriendView().environmentObject(authManager).environmentObject(fireStoreManager)) {
                Image(systemName: "plus")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
