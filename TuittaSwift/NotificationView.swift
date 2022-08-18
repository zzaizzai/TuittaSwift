//
//  NotificationView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class NotificationViewModel: ObservableObject {
    
    @Published var notices = [Notice]()
    
    private let service = Service()
    
    @Published var errorMessages = "error"
    
    
    init(){
        self.fetchNotification()
    }
    
    func fetchNotification() {
        guard let user = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("notice").document(user.uid).collection("PostNotice").order(by: "time").getDocuments { snapshots, error in
            if let error = error {
                print(error)
                self.errorMessages = "snapshot error"
                return
            }
            
            snapshots?.documents.forEach({ doc in
                
                
                let documentId = doc.documentID
                let data = doc.data()
                
                self.notices.insert(.init(documentId: documentId, data: data), at: 0)
                
                for i in 0 ..< self.notices.count {
                    let userUid = self.notices[i].userUid
                    let postUid = self.notices[i].postUid
                    
                    self.service.getUserData(userUid: userUid) { userData in
                        self.notices[i].user = userData
                    }
                    self.service.getPostData(postUid: postUid) { postData in
                        self.notices[i].post = postData
                    }
                }
                
                
            })
        }
        
    }
    
}

struct NotificationView: View {
    
    @EnvironmentObject var vmAuth: AuthViewModel
    @ObservedObject var vm = NotificationViewModel()
    
    
    var body: some View {
        ScrollView{
            
//            Text(vm.errorMessages)
            
            VStack{
                Divider()
                ForEach(vm.notices){ notice in
                    NoticeView(notice: notice)
                    
                }
            }
            .padding(.top, 20)
            
            
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

struct NoticeView: View {
    
    let notice : Notice
    
    init(notice: Notice){
        self.notice = notice
    }
    
    @State private var showPost = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ZStack{
                    WebImage(url: URL(string: notice.user?.profileImageUrl ?? "no profile image"))
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
                
                VStack(alignment: .leading) {
                    HStack{
                        Text(notice.user?.name ?? "no name")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(notice.time.dateValue(), style: .time)
                    }
                    Text(notice.text)
                }
                
                NavigationLink("", isActive: $showPost) {
                    if let post = self.notice.post {
                        DetailPostView(post: post)
                    }
                    
                }
            }
            .padding(.horizontal)
            
            Divider()
            
        }
        .background(Color.white)
        .onTapGesture {
            self.showPost = true
        }
        
        
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
