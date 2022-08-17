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
        Firestore.firestore().collection("posts").order(by: "time").getDocuments { snapshot, _   in
            snapshot?.documents.forEach({ doc in
                let documentId = doc.documentID
                let data = doc.data()
                
                
                self.service.getUserData(userUid: data["authorUid"] as! String) { userData in
                    self.posts.insert(.init(documentId: documentId, user: userData, data: data), at: 0)
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
                            PostView(currnetProfileUid: nil, post: post)
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
    @State private var showProfile = false
    
    let currnetProfileUid : String?
    
    let post : Post
    
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
                
                ZStack{
                    WebImage(url: URL(string: post.user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(100)
                        .zIndex(1)
                        .onTapGesture {
                            if currnetProfileUid != post.user.uid {
                                self.showProfile = true
                            }
                        }
                    
                    Image(systemName: "person")
                        .frame(width: 45, height: 45)
                        .background(Color.gray)
                        .cornerRadius(100)
                    
                    NavigationLink("", isActive: $showProfile) {
                        ProfileView(user: post.user)
                    }
                    
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text(post.user.name)
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
        .background(Color.white)
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
