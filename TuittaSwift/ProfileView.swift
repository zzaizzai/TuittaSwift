//
//  ProfileView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    let user : User?
    
    @State private var showPosts : String = "posts"
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView{
                HStack{
                    ZStack{
                        WebImage(url: URL(string: vmAuth.currentUser?.profileImageUrl ?? "no image"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(100)
                            .zIndex(1)
                        
                        Image(systemName: "person")
                            .resizable()
                            .background(Color.gray)
                            .frame(width: 80, height: 80)
                            .cornerRadius(100)
                    }
                    
                    Spacer()
                }

                HStack{
                    VStack(alignment: .leading) {
                        Text(user?.name ?? "no name")
                            .font(.title)
                        Text(user?.email ?? "no email")
                        
                        HStack{
                            Text(user?.joinDate.dateValue() ?? Date(), style: .time)
                            Text(user?.joinDate.dateValue() ?? Date(), style: .date)
                        }
                        
                        HStack{
                            HStack{
                                Text("following")
                                Text("0")
                            }
                            HStack{
                                Text("follower")
                                Text("0")
                            }
                        }
                        .padding(.vertical, 1)
                    }
                    Spacer()
                }
                
                HStack{
                    
                    Spacer()
                    
                    if self.showPosts == "posts" {
                        Text("posts")
                            .fontWeight(.bold)
                    } else {
                        Text("posts")
                            .onTapGesture {
                                self.showPosts = "posts"
                            }
                    }
                    
                    Spacer()
                    if self.showPosts == "liked" {
                        Text("liked")
                            .fontWeight(.bold)
                    } else {
                        Text("liked")
                            .onTapGesture {
                                self.showPosts = "liked"
                            }
                    }
                    Spacer()
                }
                
                Divider()
                

            }
            
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: nil)
            .environmentObject(AuthViewModel())
    }
}
