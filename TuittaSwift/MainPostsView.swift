//
//  MainPostsView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainPostsView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        ScrollView{
            VStack{
                Text("text")
                
                Divider()
                PostView()
                PostView()
                PostView()
            }
        }
        .navigationTitle("posts")
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


struct PostView: View {
    var body: some View {
        LazyVStack(alignment: .leading){
            HStack(alignment: .top){
                Image(systemName: "person")
                    .frame(width: 45, height: 45)
                    .background(Color.gray)
                    .cornerRadius(100)
                
                VStack(alignment: .leading){
                    HStack{
                        Text("name")
                            .fontWeight(.bold)
                        Spacer()
                        Text("date")
                            .foregroundColor(Color.gray)
                    }
                    
                    
                    Text("contenttext messages is the content messages is the content message is si the messages that...... ")
                    
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

struct MainPostsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainPostsView()
                .environmentObject(AuthViewModel())
        }
    }
}
