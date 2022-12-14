//
//  MainMessagesView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class MainMessagesViewModel : ObservableObject {
    
    @Published var recentMessages = [Message]()
    private let service = Service()
    
    
    init(){
        self.fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let myUser = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("users").document(myUser.uid).collection("recentMessages").getDocuments { snapshots, error in
            if let error = error {
                print(error)
                return
            }
            
            snapshots?.documents.forEach({ doc in
                let docId = doc.documentID
                let data = doc.data()
                
                self.recentMessages.insert(.init(documentId: docId, data: data), at: 0)
            })
            
            for i in 0 ..< self.recentMessages.count {
                let userUid = self.recentMessages[i].fromUid
                
                self.service.getUserData(userUid: userUid) { userData in
                    self.recentMessages[i].user = userData
                }
            }
        }
    }
}

struct MainMessagesView: View {
    
    
    @ObservedObject var vm = MainMessagesViewModel()
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        ScrollView{
            ForEach(vm.recentMessages){ message in
                RecentMessageView(recentMessage: message)
            }
        }
//        .padding(.top, 5)
        .navigationBarTitle("Messsages")
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
        .safeAreaInset(edge: .top) {
            navBar
        }
    }
    
    private var navBar : some View {
        
        ZStack{
            
            HStack{
                
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
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        vmAuth.showMenu = true
                    }
                }
                
                
                Spacer()
                
            }
            
            
            Text("messages")
                .fontWeight(.bold)
        }
        .frame(width: .infinity, height: 50)
        .background(Color.init(white: 0.9))
        
        
        
    }
}

class RecentMessageViewModel: ObservableObject {
}

struct RecentMessageView: View {
    
    let recentMessage : Message
    @EnvironmentObject var vmAuth: AuthViewModel
    
    
    @State private var showMessage = false
    
    var body: some View {
        
        
        HStack(alignment: .top) {
            ZStack{
                WebImage(url: URL(string: recentMessage.user?.profileImageUrl ?? "profile"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(100)
                    .zIndex(1)
                
                Image(systemName: "person")
                    .resizable()
                    .background(Color.gray)
                    .frame(width: 60, height: 60)
                    .cornerRadius(100)
            }
            
            VStack(alignment: .leading) {
                HStack{
                    Text(recentMessage.user?.name ?? "name")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(recentMessage.time.dateValue(), style: .time)
                }
                Text(recentMessage.chatText)
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
            }
            
            NavigationLink("", isActive: $showMessage) {
                ChatMessagesView(chatUser: recentMessage.user)
            }
            
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .padding(.horizontal)
        .onTapGesture {
            self.showMessage.toggle()
            
            
            
        }
        

    }
    

}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView{
            MainMessagesView()
                .environmentObject(AuthViewModel())
//        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(post: nil)
//    }
//}
