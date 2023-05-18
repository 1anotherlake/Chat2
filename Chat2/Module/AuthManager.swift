//
//  AuthManager.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/13.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseAuthCombineSwift
import GoogleSignIn

class AuthManager: ObservableObject {
    @Published var currentUser: Firebase.User? {
        didSet {
            if count > 0 && currentUser != nil {
                login = true
                fetchProfile(uid: currentUser!.uid)
            }
            if currentUser == nil {
                login = false
            }
            count += 1
        }
    }
    @Published var userName: String = "익명"
    @Published var stateMessage: String = "초기 메시지"
    @Published var friend: [String] = [] {
        didSet {
            friendProfile = friend.map {
                return fetchFriend(uid: $0)
            }
        }
    }
    @Published var friendProfile: [User] = []
    @Published var count: Int = 0
    @Published var login: Bool = false
    @Published var isEmpty: Bool = true
    
    enum errors: Error {
        case nothing
    }
    
    func registerUser(email: String, passwd: String) {
        Auth.auth().createUser(withEmail: email, password: passwd) { result, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            print(user.uid)
        }
    }
    
    func login(email: String, passwd: String) {
        DispatchQueue.global(qos: .userInteractive).sync {
            Auth.auth().signIn(withEmail: email, password: passwd) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                // ...
                if let error = error {
                    print("error : ",error.localizedDescription)
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout Error : ", error.localizedDescription)
        }
        currentUser = nil
        userName = "익명"
        stateMessage = "초기 메시지"
        friend = []
        friendProfile = []
        count = 0
        login = false
        isEmpty = true
    }
    
    func fetchCurrentUser() -> String {
        let user = Auth.auth().currentUser
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
            // ...
            return uid
        }
        return "nil"
    }
    
    let db = Firestore.firestore()
    
    func fetchProfile(uid: String) {
        let ref = db.collection("profile")
        let userRef = ref.document(uid)
        print(uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let data = document.data()
                self.userName = data?["name"] as? String ?? "익명"
                self.stateMessage = data?["stateMessage"] as? String ?? "초기 메시지"
                self.friend = data?["friend"] as? [String] ?? []
                
            } else {
                print("Document does not exist")
            }
        }

    }
    
    func fetchFriend(uid: String) -> User {
        let ref = db.collection("profile")
        let userRef = ref.document(uid)
        
        var name: String = "nil"
        var stateMessage: String = ""
        
        DispatchQueue.global(qos: .userInteractive).sync {
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let data = document.data()
                    name = data?["name"] as? String ?? "익명"
                    stateMessage = data?["stateMessage"] as? String ?? "초기 메시지"
                } else {
                    print("Document does not exist")
                }
            }
        }
        return User(name: name, stateMessage: stateMessage, uid: uid)
    }
    
    func saveProfile(name: String, stateMessage: String, uid: String) {
        let ref = db.collection("profile")
        let userRef = ref.document(uid)
        userRef.setData([
            "name" : name,
            "stateMessage" : stateMessage,
            "friend" : friend,
            "uid" : uid
        ]) { err in
            if let err = err {
                print("Error adding Profile: \(err)")
            } else {
                print("Profile added with ID: \(userRef.documentID)")
            }
        }
    }
    
    func addFriend(uid: String) {
        friend.append(uid)
        fetchFriend(uid: uid)
        saveProfile(name: userName, stateMessage: stateMessage, uid: self.currentUser?.uid ?? "")
        print(friendProfile)
    }
    
}
