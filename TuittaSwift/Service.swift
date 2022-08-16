//
//  Service.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import Firebase

struct Service {
    
    func getUserData(userUid: String, completion: @escaping (User)-> Void) {
        
        Firestore.firestore().collection("users").document(userUid).getDocument { snapshot, _ in
            guard let documentId = snapshot?.documentID else { return }
            guard let data = snapshot?.data() else { return }
            
            let userData = User(documentId: documentId, data: data)
            
            completion(userData)
        }
        
    }
}
