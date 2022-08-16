//
//  DetailPostView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI
import SDWebImageSwiftUI

class DetailPostViewModel: ObservableObject {
    
    
    @Published var post : Post?
    
    init(post: Post?){
        self.post = post
    }
}


struct DetailPostView: View {
    
    @ObservedObject var vm : DetailPostViewModel
    
    
    init(post: Post?) {
        self.vm = DetailPostViewModel(post: post)
        
    }
    
    

    
    var body: some View {
        VStack{
            ScrollView{
                
                LazyVStack(alignment: .leading){
                    VStack(alignment: .leading) {
                        HStack(alignment: .top){
                            
                            ZStack{
                                WebImage(url: URL(string: vm.post?.authorProfileUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(100)
                                    .zIndex(1)
                                
                                Image(systemName: "person")
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray)
                                    .cornerRadius(100)
                                
                            }
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text(vm.post?.authorName ?? "user name")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                Text(vm.post?.authorEmail ?? "user email")
                                
                            }
                            Spacer()
                            
                            Text("...")
                        }
                        
                        Text(vm.post?.postText ?? "post text")
                            .font(.title)
                        
                        HStack{
                            Text(vm.post?.time.dateValue() ?? Date(), style: .time)
                            Text(vm.post?.time.dateValue() ?? Date(), style: .date)
                        }
                        .foregroundColor(Color.gray)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    
                    
                    HStack(alignment: .center) {
                        
                        Spacer()
                        
                        Image(systemName: "message")
                            .onTapGesture {
                                print("comment")
                            }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.2.squarepath")
                            .onTapGesture {
                                print("repost")
                            }
                        
                        Spacer()
                        
                        Group{
                            Image(systemName: "heart")
                                .onTapGesture {
                                    print("like it")
                                }
                        }
                        
                        Spacer()
                    }
                    .font(.title3)
                    .padding(.vertical, 3)
                    
                    
                }
                
                Divider()
                
                // comment text field
                DetailPostCommentView()
                DetailPostCommentView()
                
            }
            

        }
    }
}

struct DetailPostCommentView: View {
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
                
                ZStack{
                    WebImage(url: URL(string: ""))
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
                
                VStack(alignment: .leading){
                    HStack{
                        Text("name")
                            .fontWeight(.bold)
                        Spacer()
                        Text("time")
                            .foregroundColor(Color.gray)
                    }
                    
                    
                    Text("text")
                    
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
    }
}

struct DetailPostView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPostView(post: nil)
    }
}
