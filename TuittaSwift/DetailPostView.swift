//
//  DetailPostView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase



class DetailPostViewModel: ObservableObject {
    
    private let service = Service()
    @Published var comments = [Comment]()
    
    @Published var post : Post?
    
    @Published var commentText : String = ""
    
    init(post: Post?){
        self.post = post
        fetchComments(post: post)
    }
    
    func fetchComments(post: Post? ) {
        
        guard let post = post else { return }
        
        Firestore.firestore().collection("posts").document(post.id).collection("comments").order(by: "time").getDocuments { snapshots, _ in
            
            snapshots?.documents.forEach({ doc in
                let documentId = doc.documentID
                let data = doc.data()
                
                self.service.getUserData(userUid: post.authorUid) { userData in
                    self.comments.append(.init(documentId: documentId, user: userData, data: data))
                }
               
            })
        }
    }
    
    func replyComment(post: Post?, user: User?) {
        
        guard let post = post else { return }
        guard let user = user else { return }
        
        
        let data = [
            "userUid" : user.uid,
            "time" : Date(),
            "postUid" : post.id,
            "commentText" : self.commentText
        ] as [String:Any]
        
        Firestore.firestore().collection("posts").document(post.id).collection("comments").document().setData(data) { error in
            if let error = error {
                print(error)
                return
            }
            
            
            //notice 
            
            let noticeData = [
                "type" : "comment",
                "time" : Date(),
                "userUid" : user.uid,
                "postUid" : post.id,
                "text" : self.commentText,
            ] as [String:Any]
            
            Firestore.firestore().collection("notice").document(post.user.uid).collection("PostNotice").document().setData(noticeData) { errpr in
                if let error = error {
                    print(error)
                    return
                }
                
                self.commentText = ""
            }
        }
    }
}


struct DetailPostView: View {
    
    @ObservedObject var vm : DetailPostViewModel
    @EnvironmentObject var vmAuth: AuthViewModel
    
    
    init(post: Post?) {
        self.vm = DetailPostViewModel(post: post)
        
    }
    
    var body: some View {
        VStack{
            ScrollView{
                
                LazyVStack(alignment: .leading){
                    VStack(alignment: .leading) {
                        HStack(alignment: .top){
                            
                            ZStack{
                                WebImage(url: URL(string: vm.post?.user.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(100)
                                    .zIndex(1)
                                
                                Image(systemName: "person")
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray)
                                    .cornerRadius(100)
                                
                            }
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text(vm.post?.user.name ?? "user name")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                Text(vm.post?.user.email ?? "user email")
                                
                            }
                            Spacer()
                            
                            Text("...")
                        }
                        
                        Text(vm.post?.postText ?? "post text")
                            .font(.title)
                        
                        HStack{
                            Text(vm.post?.time.dateValue() ?? Date(), style: .time)
                            Text(vm.post?.time.dateValue() ?? Date(), style: .date)
                        }
                        .foregroundColor(Color.gray)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    
                    
                    HStack(alignment: .center) {
                        
                        Spacer()
                        
                        Image(systemName: "message")
                            .onTapGesture {
                                print("comment")
                            }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.2.squarepath")
                            .onTapGesture {
                                print("repost")
                            }
                        
                        Spacer()
                        
                        Group{
                            Image(systemName: "heart")
                                .onTapGesture {
                                    print("like it")
                                }
                        }
                        
                        Spacer()
                    }
                    .font(.title3)
                    .padding(.vertical, 3)
                    
                }
                
                Divider()
                
                // comment text field
                ForEach(vm.comments) { comment in
                    DetailPostCommentView(comment: comment)
                }
                
            }
            
            bottomChat
//                .padding(.vertical, 50)
            
        }
    }
    
    
    private var bottomChat: some View{
        HStack{
            TextField("reply a message", text: $vm.commentText)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(30)
                .padding(.vertical, 10)
            
            if vm.commentText.isEmpty {
                Image(systemName: "paperplane")
                    .font(.system(size: 25))
                    .foregroundColor(Color.init(white: 0.7))
                
            } else {
                Button {
                    vm.replyComment(post: vm.post, user: vmAuth.currentUser)
                    
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 25))
                        .foregroundColor(Color.white)
                }
                
            }
        }
        .padding(.horizontal)
        .background(Color.gray)
    }
}

struct DetailPostCommentView: View {
    
    let comment: Comment
    
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
                
                ZStack{
                    WebImage(url: URL(string: comment.user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(100)
                        .zIndex(1)
                    
                    Image(systemName: "person")
                        .frame(width: 45, height: 45)
                        .background(Color.gray)
                        .cornerRadius(100)
                    
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text(comment.user.name)
                            .fontWeight(.bold)
                        Spacer()
                        HStack{
                            Text(comment.time.dateValue(), style: .time)
                        }
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(comment.commentText)
                    
                    HStack{
                        Image(systemName: "message")
                            .onTapGesture {
                                print("comment")
                            }
                        Text("0")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.2.squarepath")
                            .onTapGesture {
                                print("repost")
                            }
                        Text("0")
                        
                        Spacer()
                        
                        Group{
                            Image(systemName: "heart")
                                .onTapGesture {
                                    print("like it")
                                }
                            Text("0")
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 1)
                }
                
                Spacer()
                
                Text("...")
            }
            .padding(.horizontal)
            
            Divider()
        }
    }
}

struct DetailPostView_Previews: PreviewProvider {
    static var previews: some View {
//        DetailPostView(post: nil)
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
