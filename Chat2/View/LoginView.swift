//
//  LoginView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/13.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import PopupView

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State var email: String = ""
    @State var password: String = ""
    @State var popup: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            TextField("Passwd", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            Button("Login") {
                authManager.login(email: email, passwd: password)
                popup.toggle()
            }
            .padding(5)
            .onAppear {
                var handle = Auth.auth().addStateDidChangeListener { auth, user in
                    if let user = user {
                      // The user's ID, unique to the Firebase project.
                      // Do NOT use this value to authenticate with your backend server,
                      // if you have one. Use getTokenWithCompletion:completion: instead.
                      let uid = user.uid
                      let email = user.email
                      let photoURL = user.photoURL
                      var multiFactorString = "MultiFactor: "
                      for info in user.multiFactor.enrolledFactors {
                        multiFactorString += info.displayName ?? "[DispayName]"
                        multiFactorString += " "
                      }
                        authManager.currentUser = user
                    }
                }
            }
            Button("회원가입") {
                authManager.registerUser(email: email, passwd: password)
            }
            .foregroundColor(Color.pink.opacity(0.7))
        }
        .popup(isPresented: $popup, view: {
            HStack(alignment: .center,spacing: 10){
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 25))
                                    .padding(.leading, 5)
                                    .foregroundColor(Color.white)
                                VStack(alignment: .leading, spacing: 2){
                                    Text("로그인 및 회원가입 오류")
                                        .fontWeight(.black)
                                        .foregroundColor(Color.white)
                                    Text("비밀번호는 6자리 이상입니다.")
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .foregroundColor(Color.white)
                                }
                                .padding(.trailing, 15)
                    //                    .background(Color.red)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.orange)
                            .cornerRadius(25)
                            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 55)
        }) {
            $0.animation(.easeInOut)
                .type(.toast)
                .position(.top)
                .autohideIn(3)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
