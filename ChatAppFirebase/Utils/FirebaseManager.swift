//
//  FirebaseManager.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/1/23.
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

