//
//  MainMessagesView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 12/31/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUser {
    let uid, profileImageUrl, email: String
    
}

class MainMessagesViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init(){
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.FB.auth.currentUser?.uid else{
            return }
        self.errorMessage = "\(uid)"

        FirebaseManager.FB.db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error{
                print("Error getting document data \(error)")
                return
            }
            guard let data = snapshot?.data() else{
                return }
           print(data)
            self.errorMessage = data.description
            let uid = data["uid"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            self.chatUser = ChatUser(uid: uid, profileImageUrl: profileImageUrl, email: email)
        }
        
    }
}

struct MainMessagesView: View {
    @State var isLogoutOptionShown = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
//                Text("USER ID \(vm.chatUser?.uid ?? "")")
                customNavbar
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom
            )
            .navigationBarHidden(true)
        }
    }
    
    private var customNavbar: some View{
        HStack(spacing: 20) {
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? "")).resizable()
                .frame(width: 50, height: 50)
                .scaledToFit()
                .clipped()
                .cornerRadius(64)
                .overlay(RoundedRectangle(cornerRadius: 50)
                    .stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
//            Image(systemName: "person.fill").font(.system(size: 24, weight: .heavy))
            VStack(alignment: .leading, spacing: 4) {
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                Text("\(email)")
                    .font(.system(size: 20, weight: .bold))
                HStack(){
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    
                }
            }
            Spacer()
            Button {
                isLogoutOptionShown.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
            }
            
        }.padding()
            .actionSheet(isPresented: $isLogoutOptionShown) {
                ActionSheet(title: Text("Settings"),
                            message: Text("What do you want to do?"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("Sign Out"),
                                    action: {
                                        print("Sign out")
                                    }
                                    
                                )
                            ]
                )
            }
    }
    
    
    private var messagesView: some View{
        ScrollView{
            ForEach(0...10, id: \.self){ num in
                VStack {
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 30))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.label), lineWidth: 1))
                        VStack(alignment: .leading){
                            Text("Username")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Sent Message to User")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
    }
    
    
    private var newMessageButton: some View{
        Button {
            // action
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(24)
            .foregroundColor(Color.white)
            .padding(.horizontal)
            .shadow(radius: 16)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        
        MainMessagesView()
    }
}

