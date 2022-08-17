//
//  MainTabView2.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI

struct MainTabView2: View {
    
    @State var tabIndex : Int = 0
    
    @EnvironmentObject var vmAuth : AuthViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                NavigationView{
                    ZStack{
                        if self.tabIndex == 0 {
//                            NavigationView{
                                MainPostsView()
//                            }
                            
                        } else if self.tabIndex == 1 {
//                            NavigationView{
                                ExploreView()
//                            }
                            
                        } else if self.tabIndex == 2 {
                            NotificationView()
                            
                        } else if self.tabIndex == 3 {
                            MainMessagesView()
                            
                        }
                        
                        //for the maintain the bottomtap after move to another page
                        NavigationLink("", isActive: $vmAuth.showProfile) {
                            ProfileView(user: vmAuth.currentUser)
                        }

                     
                    }
                    
                    
                }
                    
                    
                
            }
            .padding(.bottom, 50)
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
                
                if self.tabIndex == 0 {
                    Image(systemName: "person.fill")
                        .onTapGesture {
                            if vmAuth.showProfile {
                                vmAuth.showProfile = false
                            }
                        }
                } else {
                    Image(systemName: "person")
                        .onTapGesture {
                            vmAuth.showProfile = false
                            self.tabIndex = 0
                            
                        }
                }
                
                Spacer()
                
                
                if self.tabIndex == 1 {
                    Image(systemName: "message.fill")
                        .onTapGesture {
                            if vmAuth.showProfile {
                                vmAuth.showProfile = false
                            }
                        }
                } else {
                    Image(systemName: "message")
                        .onTapGesture {
                            vmAuth.showProfile = false
                            self.tabIndex = 1
                            
                            
                        }
                }
                
                Spacer()
                
                if self.tabIndex == 2 {
                    Image(systemName: "bell.fill")
                        .onTapGesture {
                            if vmAuth.showProfile {
                                vmAuth.showProfile = false
                            }
                        }
                    
                } else {
                    Image(systemName: "bell")
                        .onTapGesture {
                            vmAuth.showProfile = false
                            self.tabIndex = 2
                        }
                }
                
                Spacer()
                
                if self.tabIndex == 3 {
                    Image(systemName: "envelope.fill")
                        .onTapGesture {
                            if vmAuth.showProfile {
                                vmAuth.showProfile = false
                            }
                        }
                } else {
                    Image(systemName: "envelope")
                        .onTapGesture {
                            vmAuth.showProfile = false
                            self.tabIndex = 3
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
