//
//  RecentMessagesView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct Message: Identifiable, Codable {
    
    var id: String {documentId}
    
    let documentId: String
    let chatText, fromUid : String
    let time : Timestamp
    
    let user: User
    
    init(documentId: String, fromUser: User, data: [String:Any]) {
        self.documentId = documentId
        self.chatText = data["chatText"] as? String ?? "no chatText"
        self.fromUid = data["fromUid"] as? String ?? "no fromUid"
        self.time = data["time"] as? Timestamp ?? Timestamp()
        
        self.user = fromUser
    }
}


class ChatMessagesViewModel : ObservableObject{
    
    @Published var chatUser: User?
    @Published var chatText = ""
    @Published var messages = [Message]()
    
    let service = Service()
    
    init(chatUser: User?) {
        self.chatUser = chatUser
        self.fetchMessages(chatUser: chatUser)
        
        
    }
    
    
    func fetchMessages(chatUser: User? ){
        guard let myUser = Auth.auth().currentUser else { return }
        guard let chatUser = chatUser else { return }
        
        Firestore.firestore().collection("messages").document(myUser.uid).collection(chatUser.uid).order(by: "time").getDocuments { snapshots, error in
            if let error = error {
                print(error)
                return
            }
            
            snapshots?.documents.forEach({ doc in
                let docId = doc.documentID
                let data = doc.data()
                
                guard let fromUid = data["fromUid"] as? String else { return }
                
                self.service.getUserData(userUid: fromUid) { fromUser in
                    self.messages.insert(.init(documentId: docId, fromUser: fromUser, data: data), at: 0)
                }
                
                
                
                
            })
        }
    }
    
    func sendMessage() {
        guard let myUser = Auth.auth().currentUser else { return }
        guard let chatUser = self.chatUser else { return}
        
        
        //my user DB
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
                        WebImage(url: URL(string: message.user.profileImageUrl))
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
