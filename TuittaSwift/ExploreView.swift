//
//  ExploreView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/16.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        ScrollView{
            Text("show all users")
            
            NavigationLink("", isActive: $vmAuth.showProfile) {
                ProfileView(user: vmAuth.currentUser)
            }
        }
        .navigationBarTitle("explore")
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

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .environmentObject(AuthViewModel())
    }
}
