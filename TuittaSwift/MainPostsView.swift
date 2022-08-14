//
//  MainPostsView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI

struct MainPostsView: View {
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
            Image(systemName: "person")
                .background(Color.gray)
                .cornerRadius(100)
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
                        Spacer()
                        Text("date")
                            .foregroundColor(Color.gray)
                    }
                    Text("contenttext messages is the content messages is the content message is si the messages that...... ")
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
        }
    }
}
