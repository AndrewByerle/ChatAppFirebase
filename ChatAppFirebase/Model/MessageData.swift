//
//  MessageData.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/5/23.
//

import SwiftUI

struct MessageData: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, chatText: String
   
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as! String
        self.toId = data["toId"] as! String
        self.chatText = data["chatText"] as! String
    }
}
