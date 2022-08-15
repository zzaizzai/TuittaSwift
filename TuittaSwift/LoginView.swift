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
    
    @EnvironmentObject var vmAuth : AuthViewModel
    
    @State private var showRegisterPage: Bool = false
    
    
    var body: some View {
        if self.showRegisterPage == true {
            registerPage
            
        } else {
            loginPage
        }
    }
    
    
    @State private var loginEmail : String = "test@test.com"
    @State private var loginPassword : String = "password"
    
    private var loginPage: some View {
        VStack{
            
            Text("Log In Page")
                .font(.title)
                .padding()
            
            Group{
                TextField("email", text: $loginEmail)
                TextField("password", text: $loginPassword)
            }
            .autocapitalization(.none)
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
                    self.loginButton()
                    
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
            
            Text(vmAuth.errorMessage)
            
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
    
    func loginButton(){
        vmAuth.login(email: self.loginEmail, password: self.loginPassword)
    }
    
    @State private var registerName : String = ""
    @State private var registerEmail : String = ""
    @State private var registerPassword : String = ""
    @State private var registerPasswordCheck : String = ""
    
    @State private var showImagePicker = false
    @State private var profileImage : UIImage?
    @State private var registerErrorMessage : String = "message"
    
    private var registerPage: some View {
        VStack{
            
            Text("Register Page")
                .font(.title)
                .padding()
            
            Group{
                TextField("name", text: $registerName)
                TextField("email", text: $registerEmail)
                TextField("password", text: $registerPassword)
                TextField("passwordCheck", text: $registerPasswordCheck)
            }
            .autocapitalization(.none)
            .padding()
            .background(Color.init(white: 0.9))
            .cornerRadius(20)
            .padding()
            
            
            Button {
                self.showImagePicker.toggle()
            } label: {
                if let myProfrilImage = self.profileImage {
                    Image(uiImage: myProfrilImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(100)
                    
                    
                } else {
                    Image(systemName: "person")
                        .font(.system(size: 60))
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.black)
                        .background(Color.gray)
                        .cornerRadius(100)
                }
            }

            
            
            //no filled
            if self.registerName.isEmpty || self.registerEmail.isEmpty || self.registerPassword.isEmpty || self.registerPasswordCheck.isEmpty || self.profileImage == nil {
                HStack{
                    Spacer()
                    Text("Sign Up")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .background(Capsule().fill(Color.init(red: 0.5, green: 0.4, blue: 0.1)))
                .padding()
                
                //filled
            } else {
                
                Button {
                    registerButton()
                    
                } label: {
                    Spacer()
                    Text("Sign Up")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .background(Capsule().fill(Color.init(red: 0.4, green: 0.4, blue: 0.1)))
                .padding()
            }
            
            Text(self.registerErrorMessage)
                .fontWeight(.bold)
            
            Text(vmAuth.errorMessage)
                .fontWeight(.bold)
            
            
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
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }
    
    func clearRegisterTextFields() {
        self.registerName = ""
        self.registerEmail = ""
        self.registerPassword = ""
        self.registerPasswordCheck = ""
    }
    
    
    func registerButton() {
        guard let profileImage = self.profileImage else { return }
        
        if self.registerPassword != self.registerPasswordCheck {
            self.registerErrorMessage = "password check error"
            return
        }
        
        vmAuth.register(email: self.registerEmail, password: self.registerPassword, name:self.registerName , profileImage: profileImage ) { didRegister in
            if didRegister == true {
                self.registerErrorMessage = "create account done"
                sleep(2)
                self.showRegisterPage = false
                
            }
        }
        
        
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
