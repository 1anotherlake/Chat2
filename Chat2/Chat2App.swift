//
//  Chat2App.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/01.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAuthCombineSwift
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var fireStoreManager = FireStoreManager()
    @StateObject var authManager = AuthManager()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .environmentObject(fireStoreManager)
              .environmentObject(authManager)
      }
    }
  }
}
