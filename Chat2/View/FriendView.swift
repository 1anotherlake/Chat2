//
//  FriendView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/17.
//

import SwiftUI

struct FriendView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        List(authManager.friendProfile, id: \.uid) { friend in
            Text(friend.name)
            Text(friend.stateMessage)
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
            .environmentObject(FireStoreManager())
            .environmentObject(AuthManager())
    }
}
