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
    let chatUser: ChatUser?
    @Published var errorMessage = ""
    @Published var sentMessages = [MessageData]()
    
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.FB.auth.currentUser?.uid else {
            return }
        guard let toId = chatUser?.uid else {
            return }
        FirebaseManager.FB.db.collection("messages").document(fromId).collection(toId).order(by: "timestamp").addSnapshotListener { snapshot, error in
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
        }
        
        let recipientDocument = FirebaseManager.FB.db.collection("messages").document(toId).collection(fromId).document()
        recipientDocument.setData(messageData){ error in
            if let error = error{
                self.errorMessage = "failed to upload message to firestore: \(error)"
                return
            }
        }
        self.chatText = ""
    }
}



struct ChatLogView: View {
    @ObservedObject var vm: ChatLogViewModel
    
    init(chatUser: ChatUser?){
        vm = .init(chatUser: chatUser)
    }
    
    var body: some View {
        MessagesView
            .navigationTitle(vm.chatUser?.email ?? "T")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var MessagesView: some View {
        ScrollView{
            Text(vm.errorMessage)
            ForEach(vm.sentMessages) { msg in
                VStack{
                    if msg.fromId == FirebaseManager.FB.auth.currentUser?.uid {
                        HStack {
                            Spacer()
                            HStack {
                                Text(msg.chatText)
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
                                Text(msg.chatText)
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
            HStack{ Spacer() }
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
            // TextEditor is preferred choice
            TextEditor(text: $vm.chatText)
                .frame(height: 50)
//            TextField("Description", text: $vm.chatText)
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
