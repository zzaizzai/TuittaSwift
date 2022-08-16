//
//  NotificationView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    
    var body: some View {
        ScrollView{
            
            HStack(alignment: .top) {
                Image(systemName: "person")
                    .resizable()
                    .background(Color.gray)
                    .frame(width: 50, height: 50)
                    .cornerRadius(100)
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("name")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("time")
                    }
                    Text("comment text")
                }
                
                
            }
            .padding(.horizontal)
            
            
        }
        .navigationTitle("notification")
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

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NotificationView()
                .environmentObject(AuthViewModel())
        }
    }
}
