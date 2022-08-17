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

struct Post: Identifiable, Codable {
    
    var id : String { documentId }
    
    let documentId: String
    let authorUid, postText : String
    let authorName, authorEmail, authorProfileUrl : String
    let postImageUrl: String
    let time: Timestamp
    var likes: Int
    
    var didLike: Bool? = false
    
    let user: User
    
    init(documentId: String, user:User, data: [String:Any] ) {
        self.documentId = documentId
        self.authorUid = data["authorUid"] as? String ?? "no authorUid"
        self.authorEmail = data["authorEmail"] as? String ?? "no authorEmail"
        self.authorName = data["authorName"] as? String ?? "no authorName"
        self.authorProfileUrl = data["authorProfileUrl"] as? String ?? "no authorProfileUrl"
        self.postText = data["postText"] as? String ?? "no postText"
        self.postImageUrl = data["postImageUrl"] as? String ?? "no postImageUrl"
        
        self.time = data["time"] as? Timestamp ?? Timestamp()
        self.likes = data["likes"] as? Int ?? 0
        
        self.user = user
    }
}


struct Comment: Identifiable, Codable {
    
    var id: String {documentId}
    
    let documentId: String
    let userUid, postUid, commentText: String
    let time: Timestamp
    
    var liked : Bool = false
    
    let user : User
    
    init(documentId: String, user: User, data: [String:Any]) {
        self.documentId = documentId
        self.userUid = data["userUid"] as? String ?? "no userUid"
        self.postUid = data["postUid"] as? String ?? "no postUid"
        self.commentText = data["commentText"] as? String ?? "no commentText"
        
        self.time = data["time"] as? Timestamp ?? Timestamp()
        
        self.user = user
    }
}


struct Notice: Identifiable, Codable {
    
    var id: String {documentId}
    
    let documentId: String
    let postUid, userUid, text: String
    let time: Timestamp
    let type : String
    
    let user: User
    let post: Post
    
    init(documentId: String,user: User, post: Post, data: [String:Any]) {
        self.documentId = documentId
        self.postUid = data["postUid"] as? String ?? "no postUid"
        self.userUid = data["userUid"] as? String ?? "no userUid"
        self.text = data["text"] as? String ?? "no text"
        self.type = data["type"] as? String ?? "no type"
        self.time = data["time"] as? Timestamp ?? Timestamp()
        
        self.user = user
        self.post = post
    }
}

struct Message: Identifiable, Codable {
    
    var id: String {documentId}
    
    let documentId: String
    let chatText, fromUid : String
    let time : Timestamp
    
    let user: User
    
    init(documentId: String, fromUser: User, data: [String:Any]) {
        self.documentId = documentId
        self.chatText = data["chatText"] as? String ?? "no chatText"
        self.fromUid = data["fromUid"] as? String ?? "no fromUid"
        self.time = data["time"] as? Timestamp ?? Timestamp()
        
        self.user = fromUser
    }
}
