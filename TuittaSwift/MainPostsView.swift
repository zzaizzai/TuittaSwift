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
    
    init() {
        self.fetchAllPosts()
    }
    
    
    func fetchAllPosts() {
        Firestore.firestore().collection("posts").order(by: "time").getDocuments { snapshot, _   in
            snapshot?.documents.forEach({ doc in
                let documentId = doc.documentID
                let data = doc.data()
                
                self.getUserData(userUid: data["authorUid"] as! String) { userData in
                    self.posts.insert(.init(documentId: documentId, user: userData, data: data), at: 0)
                }
            })
            
        }
        
    }
    
    func getUserData(userUid: String, completion: @escaping (User)-> Void) {
        
        Firestore.firestore().collection("users").document(userUid).getDocument { snapshot, _ in
            guard let documentId = snapshot?.documentID else { return }
            guard let data = snapshot?.data() else { return }
            
            let userData = User(documentId: documentId, data: data)
            
            completion(userData)
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
                            PostView(post: post)
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
                
//                NavigationLink("", isActive: $vmAuth.showProfile) {
//                    ProfileView(user: vmAuth.currentUser)
//                }

        }
    }
}


struct PostView: View {
    
    @State private var showDetailPost = false
    
    let post : Post
    
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
                
                ZStack{
                    WebImage(url: URL(string: post.authorProfileUrl))
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
                        Text(post.authorName)
                            .fontWeight(.bold)
                        Spacer()
                        Text(post.time.dateValue(), style: .time)
                            .foregroundColor(Color.gray)
                    }
                    
                    
                    Text(post.postText)
                    
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
                        //                        .foregroundColor(Color.red)
                        
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
        .onTapGesture {
            self.showDetailPost = true
        }

        NavigationLink("", isActive: $showDetailPost) {
            DetailPostView(post: self.post)
        }
    }
}

struct MainPostsView_Previews: PreviewProvider {
    static var previews: some View {
                NavigationView{
        MainPostsView()
            .environmentObject(AuthViewModel())
                }
    }
}
