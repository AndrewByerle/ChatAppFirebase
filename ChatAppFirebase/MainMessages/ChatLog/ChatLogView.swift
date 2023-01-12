//
//  ChatLogView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/3/23.
//

import SwiftUI
import Firebase

class ChatLogViewModel: ObservableObject {
    @Published var chatText = ""
    var chatUser: ChatUser?
    @Published var errorMessage = ""
    @Published var sentMessages = [MessageData]()
    
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.FB.auth.currentUser?.uid else {
            return }
        guard let toId = chatUser?.uid else {
            return }
        sentMessages.removeAll()
        
        firestoreListener = FirebaseManager.FB.db.collection("messages").document(fromId).collection(toId).order(by: "timestamp").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch messages: \(error)")
                self.errorMessage = "Failed to fetch messages: \(error)"
                return
            }
            
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    self.sentMessages.append(.init(documentId: change.document.documentID, data: data))
                }
            })
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }
    
    func handleSend(){
        print(self.chatText)
        guard let fromId = FirebaseManager.FB.auth.currentUser?.uid else {
            return }
        guard let toId = chatUser?.uid else {
            return }
        let messageData = ["fromId": fromId, "toId": toId, "chatText": self.chatText, "timestamp": Timestamp()] as [String : Any]
        
        let document = FirebaseManager.FB.db.collection("messages").document(fromId).collection(toId).document()
        document.setData(messageData){ error in
            if let error = error{
                self.errorMessage = "failed to upload message to firestore: \(error)"
                return
            }
            print("Successfully sent message")
            self.count += 1
        }
        
        let recipientDocument = FirebaseManager.FB.db.collection("messages").document(toId).collection(fromId).document()
        recipientDocument.setData(messageData){ error in
            if let error = error{
                self.errorMessage = "failed to upload message to firestore: \(error)"
                return
            }
        }
        persistRecentMessages()
        self.chatText = ""
    }
    
    
    private func persistRecentMessages() {
        guard let uid = FirebaseManager.FB.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": chatUser?.profileImageUrl as Any,
            "email": chatUser?.email as Any
        ] as [String : Any]
        
        let document = FirebaseManager.FB.db.collection("recent_messages").document(uid).collection("messages").document(toId)
        
        document.setData(data){ error in
            if let error = error {
                self.errorMessage = "Filed to save recent message: \(error)"
            }
        }
        
        let recipientDocument = FirebaseManager.FB.db.collection("recent_messages").document(toId).collection("messages").document(uid)
        
        recipientDocument.setData(data){ error in
            if let error = error {
                self.errorMessage = "Filed to save recent message: \(error)"
            }
        }
    }
    
    
    @Published var count = 0
}



struct ChatLogView: View {
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        MessagesView
            .navigationTitle(vm.chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                vm.firestoreListener?.remove()
            }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var MessagesView: some View {
        ScrollView{
            ScrollViewReader { scrollViewProxy in
                ForEach(vm.sentMessages) { message in
                    MessageView(message: message)
                }
                HStack{ Spacer() }
                    .id(Self.emptyScrollToString)
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)){
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            ChatBar
                .background(Color(.systemBackground)
                .ignoresSafeArea())
        }

    }
    
    private var ChatBar: some View {
        HStack (spacing: 20){
            // From SF Symbols
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 25))
                .foregroundColor(Color(.darkGray))
            TextEditor(text: $vm.chatText)
                .frame(height: 50)
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }.padding()
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
//            ChatLogView(chatUser: nil)
//
//        }
        MainMessagesView()
    }
}


struct MessageView: View {
    let message: MessageData
    
    var body: some View {
        VStack{
            if message.fromId == FirebaseManager.FB.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.chatText)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .regular))
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
                }
            } else{
                HStack {
                    HStack {
                        Text(message.chatText)
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .regular))
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
