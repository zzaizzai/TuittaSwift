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
    @Published var scrollCount = 0
    
    
    let service = Service()
    
    init(chatUser: User?) {
        DispatchQueue.main.async {
            self.chatUser = chatUser
            self.fetchMessages(chatUser: chatUser)
            self.scrollCount += 1
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
                    self.scrollCount += 1
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
                self.scrollCount += 1
            }
        }
    }
    
}

struct ChatMessagesView: View {
    
    @ObservedObject var vm : ChatMessagesViewModel
    @EnvironmentObject var vmAuth : AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    init(chatUser: User?) {
        self.vm = ChatMessagesViewModel(chatUser: chatUser)
        
        
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { ScrollViewProxy in
                
                VStack{
                    if vm.messages.isEmpty {
                        Text("no Chat")
                        
                    } else {
                        
                        
                        ForEach(0 ..< self.vm.messages.count, id: \.self ) { index in
                            
                            MessagesView(showProfile: true, message: self.vm.messages[index])
                            
                        }
                        
                    }
                    
                    HStack{Spacer()}
                        .id("Empty")
                    
                    
                }
                .onReceive(vm.$scrollCount) { _ in
                    withAnimation(.easeInOut(duration: 0.1))  {
                        ScrollViewProxy.scrollTo("Empty", anchor: .bottom)
                    }
                }
                
            }
        }
        .navigationBarHidden(true)
        .navigationTitle(vm.chatUser?.name ?? "chat User" )
        .safeAreaInset(edge: .bottom) {
            bottomView
        }
        .safeAreaInset(edge: .top) {
            navBar
                .opacity(0.98)
        }
    }
    private var navBar : some View {
        
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                
                Button {
                    self.dismiss()
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                    
                        .foregroundColor(Color.white)
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
            .frame(width: .infinity, height: 70)
            .background(Color.init(white: 0.9))
            
            VStack{
                ZStack{
                    WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? "profile"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .cornerRadius(100)
                        .zIndex(1)
                    
                    Image(systemName: "person")
                        .resizable()
                        .background(Color.white)
                        .frame(width: 30, height: 30)
                        .cornerRadius(100)
                }
                
                Text(vm.chatUser?.name ?? "name")
            }
            
        }
    }
    
    private var bottomView :  some View {
        
        HStack{
            Image(systemName: "")
                .padding()
            TextField("send a message", text: $vm.chatText)
                .padding(.horizontal)
                .padding(.vertical, 10)
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
                .padding(.vertical, 15)
            } else {
                Button {
                    vm.sendMessage()
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 25))
                        .foregroundColor(Color.white)
                    
                }
                //                .padding(.horizontal, 5)
                .padding(.horizontal)
                .padding(.vertical, 15)
            }
            
        }
        .background(Color.gray)
        
        
        
    }
}

struct MessagesView: View {
    
    
    var showProfile = true
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
                    
                    if self.showProfile {
                        ZStack{
                            WebImage(url: URL(string: message.user?.profileImageUrl ?? "profile"))
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
