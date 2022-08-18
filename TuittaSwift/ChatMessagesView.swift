//
//  RecentMessagesView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI





class ChatMessagesViewModel : ObservableObject{
    
    @Published var chatUser: User?
    @Published var chatText = ""
    @Published var messages = [Message]()
    
    let service = Service()
    
    init(chatUser: User?) {
        DispatchQueue.main.async {
            self.chatUser = chatUser
            self.fetchMessages(chatUser: chatUser)
        }
    }
    
    
    var firestoreListner : ListenerRegistration?
    
    
    func fetchMessages(chatUser: User? ){
        guard let myUser = Auth.auth().currentUser else { return }
        guard let chatUser = chatUser else { return }
        
        firestoreListner?.remove()
        
        Firestore.firestore().collection("messages").document(myUser.uid).collection(chatUser.uid).order(by: "time", descending: false).addSnapshotListener { snapshots, error in
            if let error = error {
                print(error)
                return
            }
            
            snapshots?.documentChanges.forEach({ change in
                if change.type == .added {
                    let docId = change.document.documentID
                    let data = change.document.data()
                    
                        self.messages.append(.init(documentId: docId, data: data))
                }
            })
            
            for i in 0 ..< self.messages.count {
                let userUid = self.messages[i].fromUid
                
                self.service.getUserData(userUid: userUid) { userData in
                    self.messages[i].user = userData
                }
            }
        }
    }
    
    func sendMessage() {
        guard let myUser = Auth.auth().currentUser else { return }
        guard let chatUser = self.chatUser else { return}
        
        
        
        
        //recent message
        let myRecentMessage = [
            "chatText": self.chatText,
            "fromUid": chatUser.uid,
            "time": Date(),
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(myUser.uid).collection("recentMessages").document(chatUser.uid).setData(myRecentMessage) { _ in
            
        }
        
        let yourRecentMessage = [
            "chatText": self.chatText,
            "fromUid": myUser.uid,
            "time": Date(),
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(chatUser.uid).collection("recentMessages").document(myUser.uid).setData(yourRecentMessage) { _ in
            
        }
        
        
        
        
        //my user DB
        //chat Messages
        let myMessageData = [
            "chatText": self.chatText,
            "fromUid": myUser.uid,
            "time": Date(),
        ] as [String : Any]
        
        Firestore.firestore().collection("messages").document(myUser.uid).collection(chatUser.uid).document().setData(myMessageData) { error in
            if let error = error {
                print(error)
                return
            }
            
            //chat user DB
            let yourMessageData = [
                "chatText": self.chatText,
                "fromUid": myUser.uid,
                "time": Date(),
            ] as [String : Any]
            
            Firestore.firestore().collection("messages").document(chatUser.uid).collection(myUser.uid).document().setData(yourMessageData) { error in
                if let error = error {
                    print(error)
                    return
                }
                
                self.chatText = ""
            }
        }
    }
    
}

struct ChatMessagesView: View {
    
    @ObservedObject var vm : ChatMessagesViewModel
    @EnvironmentObject var vmAuth : AuthViewModel
    
    
    init(chatUser: User?) {
        self.vm = ChatMessagesViewModel(chatUser: chatUser)
        
        
    }
    var body: some View {
        VStack {
            ScrollView{
                Text(vm.chatUser?.name ?? "chatUser name")
                
                if vm.messages.isEmpty {
                    Text("no Chat")
                    
                } else {
                    ForEach(vm.messages) { message in
                       MessagesView(message: message)
                    }
                }
                
            }
            HStack{
                Image(systemName: "photo")
                    .padding()
                TextField("send a message", text: $vm.chatText)
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .cornerRadius(30)
                
                if vm.chatText.isEmpty {
                    Button {
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.system(size: 25))
                            .foregroundColor(Color.init(white: 0.5))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                } else {
                    Button {
                        vm.sendMessage()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)

                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                
            }
            .background(Color.gray)
//            .padding(.bottom, 50)
        }
        .navigationTitle(vm.chatUser?.name ?? "chat User" )
        
        
    }
}

struct MessagesView: View {
    
    let message : Message
    @EnvironmentObject var vmAuth : AuthViewModel
    
    var body: some View {
        VStack{
            if message.fromUid == vmAuth.currentUser?.uid {
                HStack(alignment: .top) {
                    Spacer()
                    
                    Text(message.time.dateValue(), style: .time)
                        .foregroundColor(Color.gray)
                    
                    Text(message.chatText)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.init(red: 0.2, green: 0.3, blue: 0.9))
                        .cornerRadius(20)
                }
                .padding(.horizontal)
            } else {
                
                HStack(alignment: .top) {
                   
                    
                    ZStack{
                        WebImage(url: URL(string: message.user?.profileImageUrl ?? "profile"))
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
                    
                    Text(message.chatText)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.init(red: 0.3, green: 0.4, blue: 0.4))
                        .cornerRadius(20)
                    
                    Text(message.time.dateValue(), style: .time)
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
            }
            

        }
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    static var previews: some View {
//        ChatMessagesView(chatUser: nil)
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
