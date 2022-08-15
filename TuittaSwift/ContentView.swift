//
//  ContentView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI

struct ContentView: View {
    

    
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
            MainTabView()
                .offset(x: vmAuth.showMenu ? 200 : 0, y:0)
            
            
            if vmAuth.showMenu {
                ZStack{
                    Color.black
                        .opacity(0.3)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        vmAuth.showMenu = false
                    }
                    
                }
                .ignoresSafeArea()
            }
            
            Text("show menu")
                .frame(width: 200)
                .offset(x: vmAuth.showMenu ? 0 : -300, y: 0)
//                .background(vmAuth.showMenu ? Color.white : Color.clear)
            
        }
    }
}
