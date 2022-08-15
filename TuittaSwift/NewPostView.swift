//
//  NewPostView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewPostView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    
    @State private var uploadText : String = ""
    @FocusState private var isFocused : Bool
    @Environment(\.dismiss) private var dismiss
    
//    var didUploadPost : (Bool) -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack{
                HStack{
                    Button {
//                        self.didUploadPost(true)
                        dismiss()
                    } label: {
                        Text("Cancle")
                    }
                    
                    Spacer()
                    
                    Button {
                        self.isFocused = true
                    } label: {
                        Text("upload")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .padding()
                    }
                    
                }
                
                ScrollView{
                    HStack(alignment: .top){
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
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if self.uploadText.isEmpty {
                                Text("heelo ")
                                    .padding(10)
                                    .foregroundColor(Color.gray)
                                    .zIndex(1)
                            }
                                TextEditor(text: $uploadText)
                                .focused(self.$isFocused)
                                
                        }
                    }
                }

                
                Spacer()
                
                Text("")
                    .onAppear(perform: {
                        self.isFocused = true
                    })
                
                
            }
            .padding(.horizontal)

            .onTapGesture {
                self.isFocused = true
            }
        }
        
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView ()
        .environmentObject(AuthViewModel())
    }
}
