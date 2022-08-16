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
        ZStack(alignment: .bottom) {
            VStack{
                NavigationView{
                    ZStack{
                        if vmAuth.tabIndex == 0 {
                            MainPostsView()
                            
                        } else if vmAuth.tabIndex == 1 {
                            ExploreView()
                            
                        } else if vmAuth.tabIndex == 2 {
                            NotificationView()
                            
                        } else if vmAuth.tabIndex == 3 {
                            MainMessagesView()
                            
                        }
                        
                        //for the maintain the bottomtap after move to another page
                        NavigationLink("", isActive: $vmAuth.showProfile) {
                            ProfileView(user: vmAuth.currentUser)
                        }
                    }
                    
                    
                }
                    
                    
                
            }
            bottomTab
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
            .font(.system(size: 30))
            .padding(.vertical, 8)
            .background(Color.gray)
            
        }
        
    }
}

struct MainTabView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
