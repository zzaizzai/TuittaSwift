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
    
    init(chatUser: User?) {
        self.vm = ChatMessagesViewModel(chatUser: chatUser)
        
        
    }
    var body: some View {
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
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(chatUser: nil)
    }
}
