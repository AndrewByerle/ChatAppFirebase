//
//  ChatAppFirebaseApp.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 12/25/22.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager: NSObject{
    let db: Firestore
    let auth: Auth
    let storage: Storage
    static var FB = FirebaseManager()
    
    override init(){
        self.db = Firestore.firestore()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ChatAppFirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
