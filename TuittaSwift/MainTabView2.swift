//
//  MainTabView2.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI

struct MainTabView2: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    var body: some View {
        VStack{
            if vmAuth.tabIndex == 0 {
                NavigationView{
                    MainPostsView()
                }
                
            } else if vmAuth.tabIndex == 1 {
                NavigationView{
                    Text("explore")
                }
                
            } else if vmAuth.tabIndex == 2 {
                NavigationView{
                    Text("bell")
                }
                
            } else if vmAuth.tabIndex == 3 {
                NavigationView{
                    Text("envelope")
                }
                
            }
            
            
            VStack{
                
                bottomTab
                    .offset(x: 0, y: 50)
                    .zIndex(1)
                
                bottomBackground
            }
        }
    }
    
    private var bottomBackground : some View {
        VStack{
            HStack{
                Spacer()
            }
        }
        .frame(height: 50)
        .background(Color.gray)
    }
    
    
    private var bottomTab: some View {
        
        VStack{
            HStack{
                
                Spacer()

                if vmAuth.tabIndex == 0 {
                    Image(systemName: "person.fill")
                } else {
                    Image(systemName: "person")
                        .onTapGesture {
                            vmAuth.tabIndex = 0
                        }
                }
                
                Spacer()


                if vmAuth.tabIndex == 1 {
                    Image(systemName: "message.fill")
                } else {
                    Image(systemName: "message")
                        .onTapGesture {
                            vmAuth.tabIndex = 1
                        }
                }
                
                Spacer()
                
                if vmAuth.tabIndex == 2 {
                    Image(systemName: "bell.fill")
                } else {
                    Image(systemName: "bell")
                        .onTapGesture {
                            vmAuth.tabIndex = 2
                        }
                }
                
                Spacer()
                
                if vmAuth.tabIndex == 3 {
                    Image(systemName: "envelope.fill")
                } else {
                    Image(systemName: "envelope")
                        .onTapGesture {
                            vmAuth.tabIndex = 3
                        }
                }
                
                Spacer()
            }
            .font(.system(size: 25))
            
        }
        
    }
}

struct MainTabView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
