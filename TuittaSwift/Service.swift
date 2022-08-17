//
//  Service.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import Firebase

struct Service {
    
    func getUserData(userUid: String, completion: @escaping (User)-> Void) {
        
        Firestore.firestore().collection("users").document(userUid).getDocument { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let documentId = snapshot?.documentID else { return }
            guard let data = snapshot?.data() else { return }
            
            let userData = User(documentId: documentId, data: data)
            
            completion(userData)
        }
        
    }
    
    func getPostData(postUid: String, completion: @escaping (Post) -> Void) {
        
        Firestore.firestore().collection("posts").document(postUid).getDocument { snpashot, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let documentId = snpashot?.documentID else { return }
            guard let data = snpashot?.data() else { return }
            
            self.getUserData(userUid: data["authorUid"] as! String) { userData in
                var postData = Post(documentId: documentId, data: data)
                postData.user = userData
                
                completion(postData)
            }
            
        }
    }
}
