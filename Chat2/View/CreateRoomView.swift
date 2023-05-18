//
//  CreateRoomView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/17.
//

import SwiftUI

struct CreateRoomView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    @EnvironmentObject var authManager: AuthManager
    
    @State var name: String = ""
    @State var member: [String] = []
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView()
    }
}
