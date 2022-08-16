//
//  MainMessagesView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        ScrollView{
            ForEach(0..<10){ post in
                MessageView(post: nil)
                Divider()
                MessageView(post: nil)
                Divider()
                MessageView(post: nil)
                Divider()
            }
        }
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
    }
}

class MessageViewModel: ObservableObject {
    @Published var post: Post?
    
    
    init(post: Post?) {
        self.post = post
    }
}

struct MessageView: View {
    
    @ObservedObject var vm : MessageViewModel
    
    init(post: Post?) {
        self.vm = MessageViewModel(post: post)
    }
    
    @State private var showMessage = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .background(Color.gray)
                .frame(width: 50, height: 50)
                .cornerRadius(100)
            
            VStack(alignment: .leading) {
                HStack{
                    Text(vm.post?.authorName ?? "author name")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("time")
                }
                Text(vm.post?.postText ?? "text text text text text text text text text text text text text text text text text text text text text ")
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
            }
            
            NavigationLink("", isActive: $showMessage) {
                ChatMessagesView(chatUser: vm.post?.user ?? nil)
            }
            
        }
        .padding(.horizontal)
        .onTapGesture {
            self.showMessage.toggle()

        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainMessagesView()
                .environmentObject(AuthViewModel())
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(post: nil)
//    }
//}
