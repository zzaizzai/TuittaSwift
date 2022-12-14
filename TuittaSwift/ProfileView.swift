//
//  ProfileView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class ProfileViewModel : ObservableObject {
    
    private let service = Service()
    
    @Published var errorMessage = "error"
    
    @Published var myPosts = [Post]()
    @Published var likedPosts = [Post]()
    
    let profileUser : User?
    
    init(user: User? ){
        self.profileUser = user
        self.fetchMyPosts()
        
    }
    
    
    func fetchMyPosts() {
        guard let user = self.profileUser else { return }

        Firestore.firestore().collection("posts").whereField("authorUid", isEqualTo: user.uid).order(by: "time").getDocuments { snapshots, error in
            if let error = error {
                print(error)
                self.errorMessage = "\(error)"
                return
            }

            snapshots?.documents.forEach({ doc in
                let data = doc.data()
                let docId = doc.documentID
                
                self.myPosts.insert(.init(documentId: docId, data: data), at: 0)
                
            })
            
            for i in 0 ..< self.myPosts.count {
                let userUid = self.myPosts[i].authorUid
                
                self.service.getUserData(userUid: userUid) { userData in
                    self.myPosts[i].user = userData
                }
                
            }
        }

    }
}

struct ProfileView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    @ObservedObject var vm : ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    let user : User?
    
    @State private var showPosts : String = "posts"
    
    
    init(user : User?) {
        self.user = user
        self.vm = ProfileViewModel(user: user)
        
        
    }
    @State private var showChat = false
    var body: some View {
        VStack(alignment: .leading){
            ScrollView{
                VStack{
                    HStack{
                        ZStack{
                            WebImage(url: URL(string: user?.profileImageUrl ?? "no image"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .cornerRadius(100)
                                .zIndex(1)
                            
                            Image(systemName: "person")
                                .resizable()
                                .background(Color.gray)
                                .frame(width: 80, height: 80)
                                .cornerRadius(100)
                        }
                        
                        Spacer()
                        
                        if self.vmAuth.currentUser?.uid == self.user?.uid {
                            Text("")
                        } else {
                            Button {
                                self.showChat = true
                            } label: {
                                Image(systemName: "envelope")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 25))
                            }
                            .frame(width: 45, height: 45)
                            .background(Color.gray)
                            .cornerRadius(50)
                            
                            NavigationLink("", isActive: $showChat) {
                                ChatMessagesView(chatUser: self.user)
                            }
                            
                        }
                    }

                    HStack{
                        VStack(alignment: .leading) {
                            Text(user?.name ?? "no name")
                                .font(.title)
                            Text(user?.email ?? "no email")
                            
                            HStack{
                                Text(user?.joinDate.dateValue() ?? Date(), style: .time)
                                Text(user?.joinDate.dateValue() ?? Date(), style: .date)
                            }
                            
                            HStack{
                                HStack{
                                    Text("following")
                                    Text("0")
                                }
                                HStack{
                                    Text("follower")
                                    Text("0")
                                }
                            }
                        }
                        Spacer()
                    }
            

                    
                    
                }
                .padding(.horizontal)
                
                
                HStack{
                    
                    Spacer()
                    
                    if self.showPosts == "posts" {
                        Text("posts")
                            .fontWeight(.bold)
                    } else {
                        Text("posts")
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.6))
                            .onTapGesture {
                                self.showPosts = "posts"
                            }
                    }
                    
                    Spacer()
                    if self.showPosts == "liked" {
                        Text("liked")
                            .fontWeight(.bold)
                    } else {
                        Text("liked")
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.6))
                            .onTapGesture {
                                self.showPosts = "liked"
                            }
                    }
                    Spacer()
                }
                .font(.title3)
                .padding(.vertical, 2)
                
                Divider()
                
                if self.showPosts == "posts" {
                    ForEach(vm.myPosts){ post in
                        PostRowView(post: post, currnetProfileUid: self.user?.uid ?? nil)
                    }
                } else {
                    //liked posts
                }
                
            }
            
        }
//        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: nil)
//        ContentView()
            .environmentObject(AuthViewModel())
    }
}
