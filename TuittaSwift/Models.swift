//
//  Models.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import FirebaseFirestore


struct User: Identifiable, Codable {
    
    var id: String {documentId}
    
    let documentId: String
    let uid, name, email, profileImageUrl, profileText: String
    let joinDate: Timestamp
    var following, follower : Int
    
    init(documentId: String, data: [String:Any]) {
        self.documentId = documentId
        self.uid = data["uid"] as? String ?? "no"
        self.email = data["email"] as? String ?? "no email"
        self.name = data["name"] as? String ?? "no name"
        self.profileImageUrl = data["profileImageUrl"] as? String ?? "no profileImageUrl"
        self.profileText = data["profileText"] as? String ?? "no profileText"
        self.joinDate = data["joinDate"] as? Timestamp ?? Timestamp()
        self.following = data["following"] as? Int ?? 0
        self.follower = data["follower"] as? Int ?? 0
    }
    
    
}
