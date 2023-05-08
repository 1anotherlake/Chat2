//
//  ContentView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Chat") {
                    ChattingView()
                        .environmentObject(fireStoreManager)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
