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
    
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
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
                ForEach(0..<20) { i in
                    HStack {
                        Spacer()
                        HStack {
                            Text("Fake message for now")
                                .foregroundColor(.white)
                            .font(.system(size: 18, weight: .regular))
                        }
                        .padding()
                        .background(.blue)
                    .cornerRadius(8)
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
