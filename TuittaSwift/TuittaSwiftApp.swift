//
//  TuittaSwiftApp.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/14.
//

import SwiftUI
import Firebase
@main
struct TuittaSwiftApp: App {
    
    @StateObject var vmAuth = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vmAuth)
        }
    }
}
