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
    
    @Published var post : Post
    
    @Published var commentText : String = ""
    
    init(post: Post){
        self.post = post
        fetchComments(post: post)
    }
    
    func deletePost(done: @escaping (Bool)->() ) {
        
        let post = self.post
        
        Firestore.firestore().collection("posts").document(post.id).delete()
        
        done(true)
    }
    
    func fetchComments(post: Post? ) {
        
        self.comments.removeAll()
        
        guard let post = post else { return }
        
        Firestore.firestore().collection("posts").document(post.id).collection("comments").order(by: "time").getDocuments { snapshots, _ in
            
            snapshots?.documents.forEach({ doc in
                let documentId = doc.documentID
                let data = doc.data()
                
                self.comments.insert(.init(documentId: documentId, data: data), at: 0)
                
            })
            
            for i in 0 ..< self.comments.count {
                let userUid = self.comments[i].userUid
                
                self.service.getUserData(userUid: userUid) { userData in
                    self.comments[i].user = userData
                }
            }
        }
    }
    
    func replyComment(post: Post?, MyUser: User?) {
        
        guard let post = post else { return }
        guard let postUser = post.user else { return }
        guard let user = MyUser else { return }
        
        
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
            
            Firestore.firestore().collection("notice").document(postUser.uid).collection("PostNotice").document().setData(noticeData) { errpr in
                if let error = error {
                    print(error)
                    return
                }
                
                self.commentText = ""
            }
        }
    }
    
    func unlikeThisPost() {
        
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").document(myUser.uid).delete()
        
        self.post.didLike = false
    }
    
    func likeThisPost() {
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        
        let likeData = [
            "postUid" : self.post.id,
            "userUid" : myUser.uid,
            "time" : Date(),
        ] as [String:Any]
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").document(myUser.uid).setData(likeData) { error in
            if let error = error {
                print(error)
                return
                
            }
            
            self.post.didLike = true
        }
    }
}


struct DetailPostView: View {
    
    @ObservedObject var vm : DetailPostViewModel
    @EnvironmentObject var vmAuth: AuthViewModel
    
    @State private var showMenuOfPost = false
    @Environment(\.dismiss) private var dismiss
    
    
    init(post: Post) {
        self.vm = DetailPostViewModel(post: post)
        
    }
    
    var body: some View {
        ZStack {
            
            
            
            VStack{
                ScrollView{
                    
                    ZStack(alignment: .trailing ) {
                        
                        
                        ZStack{
                            if self.showMenuOfPost {
                                tapmenu
                                    .offset(x: -40, y: -50)
                                    .zIndex(3)
                            }
                        }
                        .animation(.easeInOut , value: showMenuOfPost)
                        
                        
                        LazyVStack(alignment: .leading){
                            VStack(alignment: .leading) {
                                HStack(alignment: .top){
                                    
                                    ZStack{
                                        WebImage(url: URL(string: vm.post.user?.profileImageUrl ?? "no uid"))
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
                                            Text(vm.post.user?.name ?? "no name")
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        Text(vm.post.user?.email ?? "no email")
                                        
                                    }
                                    Spacer()
                                    
                                    Text("...")
                                        .onTapGesture {
                                            self.showMenuOfPost.toggle()
                                        }
                                }
                                
                                Text(vm.post.postText)
                                    .font(.title)
                                
                                HStack{
                                    Text(vm.post.time.dateValue(), style: .time)
                                    Text(vm.post.time.dateValue(), style: .date)
                                }
                                .foregroundColor(Color.gray)
                                
                                Divider()
                                
                                Text("Likes: \(vm.post.likes.description)")
                                    .bold()
                                
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
                                //
                                if vm.post.didLike {
                                    Group{
                                        Image(systemName: "heart.fill")
                                            .onTapGesture {
                                                vm.unlikeThisPost()
                                            }
                                    }
                                    .foregroundColor(Color.red)
                                    
                                    
                                } else {
                                    Group{
                                        Image(systemName: "heart")
                                            .onTapGesture {
                                                vm.likeThisPost()
                                            }
                                    }
                                }
                                
                                Spacer()
                            }
                            .font(.title3)
                            .padding(.vertical, 3)
                            
                        }
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
        .onTapGesture {
            self.showMenuOfPost = false
        }
        
        
    }
    private var tapmenu : some View {
        
        ZStack{
            if vmAuth.currentUser?.uid == vm.post.user?.uid {
                VStack(spacing: 0) {
                    Group{
                        Button {
                            dismiss()
                        } label: {
                            Text("do nothing")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
                        Divider()
                        
                        Button {
                            vm.deletePost { done in
                                if done {
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            Text("delete")
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                                .padding()
                        }
                    }
                }
                .frame(width: 130)
                .background(Color.init(white: 0.7))
                .cornerRadius(20)
            } else {
                VStack(spacing: 0) {
                    Group{
                        Button {
                            dismiss()
                        } label: {
                            Text("do nothing")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
    //                    Divider()
    //
    //
    //                    Button {
    //
    //                    } label: {
    //                        Text("delete")
    //                            .fontWeight(.bold)
    //                            .foregroundColor(Color.red)
    //                            .padding()
    //                    }
                    }
                }
                .frame(width: 130)
                .background(Color.init(white: 0.7))
                .cornerRadius(20)
            }
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
                    vm.replyComment(post: vm.post, MyUser: vmAuth.currentUser)
                    
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
                    WebImage(url: URL(string: comment.user?.profileImageUrl ?? "no image"))
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
                        Text(comment.user?.name ?? "no name")
                            .fontWeight(.bold)
                        Spacer()
                        HStack{
                            Text(comment.time.dateValue(), style: .time)
                        }
                        .foregroundColor(Color.gray)
                    }
                    
                    Text(comment.commentText)
                    
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
