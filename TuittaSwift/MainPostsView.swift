//
//  MainPostsView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class MainPostsViewModel: ObservableObject{
    
    @Published var posts = [Post]()
    
    private let service = Service()
    
    
    init() {
        self.fetchAllPosts()
    }
    
    
    func fetchAllPosts() {
        
        self.posts.removeAll()
        
        Firestore.firestore().collection("posts").order(by: "time").addSnapshotListener { snapshot, _   in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let documentId = change.document.documentID
                    let data = change.document.data()
                    
                    self.posts.insert(.init(documentId: documentId, data: data), at: 0)
                }
                
            })
            //fixed for correct indexing
            for i in 0 ..< self.posts.count {
                let uid = self.posts[i].authorUid
                
                self.service.getUserData(userUid: uid) { userData in
                    self.posts[i].user = userData
                    
                    
                }
            }
            
        }
        
    }
}

struct MainPostsView: View {
    
    @ObservedObject var vm = MainPostsViewModel()
    
    @State private var showNewTweetView = false
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView{
                VStack{
                    HStack{
                        Spacer()
                    }
                    ForEach(vm.posts){ post in
                        PostRowView(post: post, currnetProfileUid: nil)
                    }
                }
            }
            .navigationTitle("posts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    VStack{
                ZStack{
                    WebImage(url: URL(string: vmAuth.currentUser?.profileImageUrl ?? "no image"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(100)
                        .zIndex(1)
                    
                    Image(systemName: "person")
                        .resizable()
                        .background(Color.gray)
                        .frame(width: 30, height: 30)
                        .cornerRadius(100)
                }
                
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        vmAuth.showMenu = true
                    }
                    
                }
            })
            
            Button {
                self.showNewTweetView.toggle()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding()
                
            }
            .background(Color.blue)
            .foregroundColor(Color.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $showNewTweetView) {
                NewPostView ()
                
            }
            
        }
    }
}

class PostRowViewModel : ObservableObject {
    
    @Published var post : Post
    let service = Service()
    @Published var numberComment : Int = 0
    
    @Published var error = "error"
    
    
    init (post: Post) {
        self.post = post
        
        self.checkLiked()
        self.checkNumberComment()
    }
    
    
    func checkNumberComment () {
        
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("comments").addSnapshotListener { snapahsot, _ in
            
            snapahsot?.documentChanges.forEach({ change in
                if change.type == .added {
                    self.numberComment += 1
                }
                
                if change.type == .removed {
                    self.numberComment -= 1
                }
            })
            
        }
    }
    
    func checkLiked() {
        
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").addSnapshotListener { snapshot, _ in
            
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    self.post.likes += 1
                }
                
                if change.type == .removed {
                    self.post.likes -= 1
                }
            })
        }
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").document(myUser.uid).addSnapshotListener { snapshot, error in
            if let error = error {
                self.error = "dsed\(error)"
                return
            }
            
            guard let data = snapshot?.data() else {
                self.post.didLike = false
                return }
            
            self.post.didLike = true
            print("\(data)")
            
            
            
        }
    }
    
    
    func unlikeThisPost() {
        
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").document(myUser.uid).delete()
        
//        self.post.didLike = false
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
            
//            self.post.didLike = true
        }
    }
    
}


struct PostRowView: View {
    
    @State private var showDetailPost = false
    @State private var showProfile = false
    @ObservedObject var vm  : PostRowViewModel
    
    let currnetProfileUid : String?
    
    init(post: Post, currnetProfileUid : String?) {
        //        self.post = post
        self.vm = PostRowViewModel(post: post)
        self.currnetProfileUid = currnetProfileUid
        
        
    }
    
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
//                Text(vm.error)
                
                ZStack{
                    WebImage(url: URL(string: vm.post.user?.profileImageUrl ?? "no url"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(100)
                        .zIndex(1)
                        .onTapGesture {
                            if currnetProfileUid != vm.post.user?.uid {
                                self.showProfile = true
                            }
                        }
                    
                    NavigationLink("", isActive: $showProfile) {
                        ProfileView(user: vm.post.user)
                    }
                    
                    Image(systemName: "person")
                        .frame(width: 45, height: 45)
                        .background(Color.gray)
                        .cornerRadius(100)
                    
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text(vm.post.user?.name ?? "no name")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vm.post.time.dateValue(), style: .time)
                            .foregroundColor(Color.gray)
                    }
                    
                    
                    Text(vm.post.postText)
                    
                    HStack{
                        Image(systemName: "message")
                            .onTapGesture {
                                print("comment")
                            }
                        Text(vm.numberComment.description)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.2.squarepath")
                            .onTapGesture {
                                print("repost")
                            }
                        Text("0")
                        
                        Spacer()
                        
                        if vm.post.didLike {
                            Group{
                                Image(systemName: "heart.fill")
                                    .onTapGesture {
                                        print("like it")
                                        vm.unlikeThisPost()
                                    }
                                Text(vm.post.likes.description)
                            }
                            .foregroundColor(Color.red)
                            
                            
                        } else {
                            Image(systemName: "heart")
                                .onTapGesture {
                                    print("like it")
                                    vm.likeThisPost()
                                }
                            Text(vm.post.likes.description)
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
        .background(Color.white)
        .onTapGesture {
            self.showDetailPost = true
        }
        
        NavigationLink("", isActive: $showDetailPost) {
            DetailPostView(post: vm.post)
        }
    }
}

struct MainPostsView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView{
        //            MainPostsView()
        ContentView()
            .environmentObject(AuthViewModel())
        //        }
    }
}
