//
//  NewPostView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class NewPostViewModel: ObservableObject {
    
    @Published var newPostText = ""
    
    func uploadNewPost(user: User?, completion: @escaping(Bool)-> Void ) {
        
        guard let uploadUser = user else { return }
        
        let data = [
            "authorUid": uploadUser.uid,
            "authorEmail" : uploadUser.email,
            "authorName" : uploadUser.name,
            "authorProfileUrl" : uploadUser.profileImageUrl,
            "postText" : self.newPostText,
            "postImageUrl" : "",
            "time" : Date(),
            
        ] as [String:Any]
        
        Firestore.firestore().collection("posts").document().setData(data) { error in
            if let error = error {
                print(error)
                return
            }
            
            completion(true)
            
        }
        
    }
    
    
}

struct NewPostView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    @ObservedObject var vm = NewPostViewModel()
    
    @FocusState private var isFocused : Bool
    @Environment(\.dismiss) private var dismiss
    
    //    var didUploadPost : (Bool) -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack{
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancle")
                    }
                    
                    Spacer()
                    
                    ZStack{
                        if vm.newPostText.isEmpty{
                            
                            Text("upload")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .foregroundColor(Color.gray)
                                .background(Color.init(red: 0.1, green: 0.4, blue: 0.8))
                                .cornerRadius(30)
                                .padding()
                            
                        } else {
                            Button {
                                vm.uploadNewPost(user: vmAuth.currentUser) { didUpload in
                                    if didUpload {
                                        vm.newPostText = ""
                                        dismiss()
                                        
                                    }
                                }
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
                            if vm.newPostText.isEmpty {
                                Text("hello world ")
                                    .padding(10)
                                    .foregroundColor(Color.gray)
                                    .zIndex(1)
                            }
                            TextEditor(text: $vm.newPostText)
                                .frame(height: 400)
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
