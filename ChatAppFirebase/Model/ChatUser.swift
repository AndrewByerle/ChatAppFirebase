//
//  ChatUser.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/3/23.
//

struct ChatUser: Identifiable {
    // id for Identifiable
    var id: String { uid }
    
    let uid, profileImageUrl, email: String
    
    init(data: [String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
    }
    
}
