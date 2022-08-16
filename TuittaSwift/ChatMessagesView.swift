//
//  RecentMessagesView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI

class ChatMessagesViewModel : ObservableObject{
    
    @Published var chatUser: User?
    
    init(chatUser: User?) {
        self.chatUser = chatUser
        
    }
}

struct ChatMessagesView: View {
    
    @ObservedObject var vm : ChatMessagesViewModel
    
    @State private var chatText : String = ""
    
    init(chatUser: User?) {
        self.vm = ChatMessagesViewModel(chatUser: chatUser)
        
        
    }
    var body: some View {
        VStack {
            ScrollView{
                Text(vm.chatUser?.name ?? "chatUser name")
                
                HStack(alignment: .top) {
                    Spacer()
                    
                    Text("time")
                        .foregroundColor(Color.gray)
                    
                    Text("chat message")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.init(red: 0.2, green: 0.3, blue: 0.9))
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                HStack(alignment: .top) {
                   
                    
                    Text("chat message")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.init(red: 0.3, green: 0.4, blue: 0.4))
                        .cornerRadius(20)
                    
                    Text("time")
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            HStack{
                Image(systemName: "photo")
                    .padding()
                TextField("", text: $chatText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                
                Button {
                    
                } label: {
                    Text("send")
                        .foregroundColor(Color.white)
                        .padding()
                        
                       
                }
                .background(Color.blue)
                .cornerRadius(20)
                .padding()
                
            }
            .background(Color.gray)
            .padding(.bottom, 50)
        }
        
        
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(chatUser: nil)
    }
}
