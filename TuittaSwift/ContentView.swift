//
//  ContentView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMyProfile = false
    

    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        if vmAuth.userSession == nil {
            LoginView()
        } else {
                mainInterfaceView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}


extension ContentView {
    
    var mainInterfaceView: some View {
        ZStack {
            NavigationView{
                ZStack{
                    MainTabView2()
                    
                    NavigationLink("", isActive: $showMyProfile) {
                        ProfileView(user: vmAuth.currentUser)
                    }
                }
                    
            }
            .offset(x: vmAuth.showMenu ? 250 : 0, y:0)
            
            
            if vmAuth.showMenu {
                ZStack{
                    Color.black
                        .opacity(0.75)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        vmAuth.showMenu = false
                        
                    }
                    
                }
                .ignoresSafeArea()
            }
            
            HStack{
                VStack{
                    SideMenuView { process in
                        if process == "profile" {
                            vmAuth.showMenu = false
                            self.showMyProfile = true
                        }
                    }
                        .frame(width: 250)
                        .background(Color.white)
                        
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                
            }
            .offset(x: vmAuth.showMenu ? 0 : -260, y: 0)
            .zIndex(1)
            
        }
        
    }
}
