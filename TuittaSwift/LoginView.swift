//
//  LoginView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI
import Firebase

class LoginViewModel : ObservableObject {
    
}

struct LoginView: View {
    
    @State private var showRegisterPage: Bool = false
    

    var body: some View {
        if self.showRegisterPage == true {
            registerPage
            
        } else {
            loginPage
        }
    }
    
    
    @State private var loginEmail : String = ""
    @State private var loginPassword : String = ""
    
    private var loginPage: some View {
        VStack{
            
            Text("Log In Page")
                .font(.title)
                .padding()
            
            Group{
                TextField("email", text: $loginEmail)
                TextField("password", text: $loginPassword)
            }
            .padding()
            .background(Color.init(white: 0.9))
            .cornerRadius(20)
            .padding()
            
            if self.loginEmail.isEmpty || self.loginPassword.isEmpty {
                HStack{
                    Spacer()
                    Text("Log In")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .background(Capsule().fill(Color.init(red: 0.3, green: 0.4, blue: 0.1)))
                .padding()
                
                
            } else {
                
                Button {
                    
                } label: {
                    Spacer()
                    Text("Log In")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .background(Capsule().fill(Color.init(red: 0.3, green: 0.5, blue: 0.1)))
                .padding()
            }
            
            Spacer()
            
            Button {
                self.showRegisterPage.toggle()
            } label: {
                Text("go to register")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }

        }
        .background(Color.init(red: 0.4, green: 0.6, blue: 1))
    }
    
    @State private var registerEmail : String = ""
    @State private var registerPassword : String = ""
    @State private var registerPasswordCheck : String = ""
    
    private var registerPage: some View {
        VStack{
            
            Text("Register Page")
                .font(.title)
                .padding()
            
            Group{
                TextField("email", text: $registerEmail)
                TextField("password", text: $registerPassword)
                TextField("passwordCheck", text: $registerPasswordCheck)
            }
            .padding()
            .background(Color.init(white: 0.9))
            .cornerRadius(20)
            .padding()
            
            
            //no filled
            if self.registerEmail.isEmpty || self.registerPassword.isEmpty || self.registerPasswordCheck.isEmpty {
                HStack{
                    Spacer()
                    Text("Sign Up")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .background(Capsule().fill(Color.init(red: 0.3, green: 0.4, blue: 0.1)))
                .padding()
                
                //filled
            } else {
                
                Button {
                    
                } label: {
                    Spacer()
                    Text("Sign Up")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .background(Capsule().fill(Color.init(red: 0.3, green: 0.5, blue: 0.1)))
                .padding()
            }
            
            Spacer()
            
            Button {
                self.showRegisterPage.toggle()
            } label: {
                Text("go to login page")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }

        }
        .background(Color.init(red: 0.4, green: 0.6, blue: 1))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
