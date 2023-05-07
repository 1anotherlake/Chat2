//
//  FireStoreManager.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/01.
//

import Foundation
import FirebaseFirestore
import Firebase

class FireStoreManager: ObservableObject {
    @Published var chatData: [Chat] = [Chat]()

    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
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
    
    func saveData(message: String, name: String) {
        let target = db.collection("talkroom").document("Default").collection("message")
        ref = target.addDocument(data: [
            "name" : name,
            "message" : message,
            "date" : Date().formatted()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    init() {
        fetchData()
    }
}
