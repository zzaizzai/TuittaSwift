//
//  SideMenuView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI


struct SideMenuView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var process : (String) -> ()
    
    
    var body: some View {
        HStack {
            
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading){
                    
                    
                    //profile image
                    
                    ZStack{
                        WebImage(url: URL(string: vmAuth.currentUser?.profileImageUrl ?? "no image"))
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
                        //                            Text("profile view show")
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            process("profile")
                        }
                    }
                    
                    
                    Text(vmAuth.currentUser?.name ?? "no user name")
                        .font(.title)
                    
                    Text(vmAuth.currentUser?.email ?? "no user email")
                        .font(.subheadline)
                        .foregroundColor(Color.init(white: 0.4))
                    
                    HStack{
                        Text("following")
                        Text(vmAuth.currentUser?.follower.description ?? "10")
                        
                        Text("follower")
                        Text(vmAuth.currentUser?.follower.description ?? "10")
                    }
                    
                    
                    
                    
                }
                
                ScrollView {
                    Button {
                        
                    } label: {
                        
                        HStack{
                            Image(systemName: "person")
                            
                            Text("profile")
                                .fontWeight(.bold)
                                .padding()
                            
                            Spacer()
                        }
                        
                    }
                    .foregroundColor(Color.black)
                    .background(Color.gray)
                    
                    
                    Button {
                        
                        vmAuth.logOut()
                        
                    } label: {
                        
                        HStack{
                            Image(systemName: "person")
                            
                            Text("log out")
                                .fontWeight(.bold)
                                .padding()
                            
                            Spacer()
                        }
                        .foregroundColor(Color.black)
                        
                    }
                    .background(Color.gray)
                    
                }
                
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 8)
        
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(process: { _  in
            
        })
            .environmentObject(AuthViewModel())
        //        ContentView()
        //            .environmentObject(AuthViewModel())
    }
}
