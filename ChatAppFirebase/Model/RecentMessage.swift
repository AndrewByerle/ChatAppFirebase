//
//  RecentMessage.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/7/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, fromId, toId: String
    let profileImageUrl, email: String
    let timestamp: Date
    
}

