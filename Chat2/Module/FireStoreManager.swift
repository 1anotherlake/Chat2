//
//  FireStoreManager.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/01.
//

import Foundation
import FirebaseFirestore

class FireStoreManager: ObservableObject {
    @Published var chatData: [Chat] = [Chat]()

    let db = Firestore.firestore()
    
    func fetchData() {
        db.collection("talkroom").document("Default").collection("message").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.chatData = querySnapshot!.documents.map { document in
                    let data = document.data()
                    let date = data["date"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let message = data["message"] as? String ?? ""
                    return Chat(date: date, name: name, message: message)
                }
            }
        }
    }
    
    func livefetch() {
        db.collection("talkroom").document("Default").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self.fetchData()
        }
    }
    
    func saveData(message: String, name: String) {
        let ref = db.collection("talkroom").document("Default").collection("message")
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd HH:mm:ss"
        var timeString = formatter.string(from: now)
        
        let userRef = ref.document(timeString)
        formatter.dateFormat = "HH:mm"
        timeString = formatter.string(from: now)
        userRef.setData([
            "name" : name,
            "message" : message,
            "date" : timeString
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(userRef.documentID)")
            }
        }
        
        db.collection("talkroom").document("Default").setData([
            "Last Message" : message
        ])
    }
    
    init() {
        livefetch()
    }
}
