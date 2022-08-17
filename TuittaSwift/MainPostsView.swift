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
        DispatchQueue.main.async {
            self.fetchAllPosts()
        }
    }
    
    
    func fetchAllPosts() {
        Firestore.firestore().collection("posts").order(by: "time").addSnapshotListener { snapshot, _   in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let documentId = change.document.documentID
                    let data = change.document.data()
                    
                    
                    self.service.getUserData(userUid: data["authorUid"] as! String) { userData in
                        self.posts.insert(.init(documentId: documentId, user: userData, data: data), at: 0)
                    }
                }
                
            })
            
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
                        PostView(post: post, currnetProfileUid: nil)
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

class PostViewModel : ObservableObject {
    
    @Published var post : Post
    
    @Published var numberComment : Int = 0
    
    
    
    init (post: Post) {
        self.post = post
        
        self.checkLiked()
        self.checkNumberComment()
    }
    
    
    func checkNumberComment () {
        Firestore.firestore().collection("posts").document(self.post.id).collection("comments").getDocuments { snpahsot, _ in
            snpahsot?.documents.forEach({ doc in
                if doc.exists {
                    self.numberComment += 1
                }
            })
        }
    }
    
    func checkLiked() {
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").getDocuments { snapshot, _ in
            snapshot?.documents.forEach({ doc in
                if doc.exists {
                    self.post.likes = self.post.likes + 1
                }
            })
        }
        
        Firestore.firestore().collection("posts").document(self.post.id).collection("liked").document(myUser.uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            
            if !data.isEmpty {
                self.post.didLike = true
            }
        }
    }
    
    func likeButton() {
        
        guard let myUser = Auth.auth().currentUser else { return }
        
        if self.post.didLike {
            
            
            Firestore.firestore().collection("posts").document(self.post.id).collection("liked").document(myUser.uid).delete()
            
            self.post.didLike = false
            self.post.likes -= 1
            
            
        } else {
            
            
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
                self.post.likes += 1
            }
        }
    }
    
}


struct PostView: View {
    
    @State private var showDetailPost = false
    @State private var showProfile = false
    @ObservedObject var vm  : PostViewModel
    
    let currnetProfileUid : String?
    
    //    let post : Post
    
    init(post: Post, currnetProfileUid : String?) {
        //        self.post = post
        self.vm = PostViewModel(post: post)
        self.currnetProfileUid = currnetProfileUid
        
        
    }
    
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
                
                ZStack{
                    WebImage(url: URL(string: vm.post.user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(100)
                        .zIndex(1)
                        .onTapGesture {
                            if currnetProfileUid != vm.post.user.uid {
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
                        Text(vm.post.user.name)
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
                                        vm.likeButton()
                                    }
                                Text(vm.post.likes.description)
                            }
                            .foregroundColor(Color.red)
                            
                        } else {
                            Image(systemName: "heart")
                                .onTapGesture {
                                    print("like it")
                                    vm.likeButton()
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
