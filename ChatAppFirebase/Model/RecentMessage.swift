//
//  RecentMessage.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/7/23.
//

import SwiftUI
import Firebase

struct RecentMessage: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let text, fromId, toId: String
    let timestamp: Timestamp
    let profileImageUrl, email: String
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.text = data["text"] as! String
        self.fromId = data["fromId"] as! String
        self.toId = data["toId"] as! String
        self.timestamp = data["timestamp"] as! Timestamp 
        self.profileImageUrl = data["profileImageUrl"] as! String
        self.email = data["email"] as! String
    }
}

