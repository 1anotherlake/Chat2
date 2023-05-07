//
//  Chat2App.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/01.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var fireStoreManager = FireStoreManager()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .environmentObject(fireStoreManager)
      }
    }
  }
}
