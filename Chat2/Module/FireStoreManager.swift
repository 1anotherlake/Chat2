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
        let timeString = formatter.string(from: now)
        
        let userRef = ref.document(timeString)
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
            "Last Message" : message,
            "lastDate" : timeString
        ])
    }
    
    func deleteData(date: String) {
        db.collection("talkroom").document("Default").collection("message").document(date).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd HH:mm:ss"
        let timeString = formatter.string(from: now)
        
        db.collection("talkroom").document("Default").setData([
            "Last Message" : "DELETE MESSAGE",
            "lastDate" : timeString
        ])
    }
    
    func updateData() {
        var lastDate: String = ""
        let docRef = db.collection("talkroom").document("Default")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                lastDate = document.get("lastDate") as! String
                // 사용할 fieldValue 값에 대한 처리
                let query = docRef.collection("message").whereField("date", isLessThan: lastDate)
                query.getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        self.chatData += querySnapshot!.documents.map { document in
                            let data = document.data()
                            let date = data["date"] as? String ?? ""
                            let name = data["name"] as? String ?? ""
                            let message = data["message"] as? String ?? ""
                            return Chat(date: date, name: name, message: message)
                        }
                    }
                }
                print("가져온 값: ", lastDate)
                print("쿼리 결과: ", query)
            } else {
                print("Can't Update : Document does not exist")
            }
        }
    }
    
    init() {
        livefetch()
    }
}
