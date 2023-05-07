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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)

            Text("Hello, world!")
            ForEach(fireStoreManager.chatData, id: \.self) { data in
                Text(data.name)
                Text(data.message)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
