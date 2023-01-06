//
//  NewMessageView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/3/23.
//

import SwiftUI
import SDWebImageSwiftUI

class NewMessageViewModel: ObservableObject{
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init(){
        fetchNewMessages()
    }
    
    private func fetchNewMessages(){
        FirebaseManager.FB.db.collection("users").getDocuments { snapshot, error in
            if let error = error{
                print("error fetching users when generating message: \(error)")
                return
            }
            snapshot?.documents.forEach({ document in
                self.users.append(ChatUser(data: document.data()))
            })
        }
    }
    
    
    
}



struct NewMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm = NewMessageViewModel()
    
    let didSelectNewUser: (ChatUser) -> ()
    
    var body: some View {
        NavigationView {
            ScrollView(){
                Text(vm.errorMessage)
                // Foreach sytax becuase ChatUser: Identifiable
                ForEach(vm.users) { user in
                    HStack {
                        Button {
                            didSelectNewUser(user)
                            dismiss()
                        } label: {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 55).stroke(Color(.label), lineWidth: 1))
                            Text(user.email)
                            Spacer()
                        }.foregroundColor(Color(.label))
                    }.padding(.horizontal)
                        .padding(.vertical, 5)
                    Divider()
                }

            }.navigationTitle("New Message")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
//        NewMessageView()
    }
}
