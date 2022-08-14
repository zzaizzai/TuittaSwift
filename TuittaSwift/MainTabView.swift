//
//  TabView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI

struct MainTabView: View {
    
    @State var titleName = ""
    var body: some View {
        TabView(selection: $titleName) {
            NavigationView{
                MainPostsView()
            }
            .tabItem {
                Image(systemName: "house")
            }
            
            NavigationView{
                Text("explore")
            }
            .tabItem {
                Image(systemName: "message")
            }
            
            NavigationView{
                Text("notification")
            }
            .tabItem {
                Image(systemName: "bell")
            }
            
            NavigationView{
                Text("messages")
            }
            .tabItem {
                Image(systemName: "envelope")
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
