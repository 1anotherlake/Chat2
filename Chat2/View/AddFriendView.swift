//
//  FriendView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/17.
//

import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    @EnvironmentObject var authManager: AuthManager
    @State var uid: String = ""
    @State var alert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("내 아이디: ")
                    Text(authManager.currentUser?.uid ?? "로그인을 해주세요")
                        .foregroundColor(Color.blue)
                }
                HStack {
                    Text("상대 아이디: ")
                    TextField("", text: $uid)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
                Button("친구 추가") {
                    alert.toggle()
                }
                    .buttonStyle(.bordered)
                    .foregroundColor(Color.black)
                    .padding()
            }
            .alert(isPresented: $alert) {
                Alert(title: Text("이 친구가 맞습니까?"),
                      primaryButton: .default(Text("네")) {
                    authManager.addFriend(uid: uid)
                },
                      secondaryButton: .cancel(Text("다시 입력")){
                    uid = ""
                })
            } // alert
        }
        .navigationTitle("친구 추가")
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
            .environmentObject(AuthManager())
    }
}
