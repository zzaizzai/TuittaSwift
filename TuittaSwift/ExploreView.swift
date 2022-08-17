//
//  ExploreView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class ExploreViewModel : ObservableObject {
    
    @Published var allUsers = [User]()
    
    init(){
        fetchAllUsersData()
    }
    
    
    func fetchAllUsersData() {
        Firestore.firestore().collection("users").getDocuments { snapshots, _ in
            snapshots?.documents.forEach({ doc in
                let documentId = doc.documentID
                let data = doc.data()
                
                self.allUsers.insert(.init(documentId: documentId, data: data), at: 0)
            })
        }
        
        
    }
}

struct ExploreView: View {
    
    @ObservedObject var vm = ExploreViewModel()
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        ScrollView{
            
            Divider()
            
            ForEach(vm.allUsers) { user in
                ExploreUserProfileView(user: user)
                
            }
            
            
        }
        .navigationBarTitle("explore")
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
        
        
    }
}

struct ExploreUserProfileView: View{
    
    let user : User
    @State private var showProfile = false
    var body: some View{
        LazyVStack {
            HStack(alignment: .top) {
                
                ZStack{
                    WebImage(url: URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                        .zIndex(1)
                    
                    Image(systemName: "person")
                        .resizable()
                        .background(Color.gray)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .fontWeight(.bold)
                            
                            Text(user.email)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                        }
                        
                        Spacer()
                        
                        Text("")
                    }
                    
                    Text("profile text")
                }
                NavigationLink("", isActive: $showProfile) {
                    ProfileView(user: self.user)
                }
            }
            .padding(.horizontal)
            
            Divider()
        }
        .background(Color.white)
        .onTapGesture {
            self.showProfile.toggle()
        }
        
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ExploreView()
                .environmentObject(AuthViewModel())
        }
    }
}
