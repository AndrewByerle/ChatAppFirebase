//
//  ContentView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 12/25/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

struct AuthView: View {
    @State var isLoginShown = false
    @State var email = ""
    @State var password = ""
    @State var loginStatus = ""
    @State var shouldShowImagePicker = false
    
    let didCompleteLoginProcess: () -> ()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 16){
                    Picker("AuthType", selection: $isLoginShown) {
                        Text("Login").tag(true)
                        Text("Create Account").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    if !isLoginShown {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack{
                                if let image = self.image{
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .scaledToFit()
                                        .cornerRadius(64)
                                } else{
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                }
                            }
                        }.overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.blue, lineWidth: 3))
                    }
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }.padding(12)
                    .background(.white)
                    Button {
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLoginShown ? "Log in" : "Create Account")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                    Text(loginStatus).foregroundColor(Color.red)
                }.padding()
            }.navigationTitle(isLoginShown ? "Log in" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.06)).ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker){
                ImagePicker(image: $image)
            }
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginShown{
            loginUser()
        } else{
            createUser()
        }
    }
    
    private func loginUser(){
        FirebaseManager.FB.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.loginStatus = "Failed to login user: \(error)"
                return
            }
            print("logged in \(authResult?.user.uid ?? "")")
            loginStatus = "logged in \(authResult?.user.uid ?? "")"
            
            self.didCompleteLoginProcess()
        }
    }
    
    
    private func createUser(){
        if image == nil{
            self.loginStatus = "Select an avatar to continue"
            return
        }
        FirebaseManager.FB.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                self.loginStatus = "Failed to create user: \(error)"
                return
            }
            print("Created user \(authResult?.user.uid ?? "")")
            loginStatus = "created account for \(authResult?.user.uid ?? "")"
            
            self.persistImageToStorage()
            
        }
    }
    
    private func persistImageToStorage(){
        guard let uid = FirebaseManager.FB.auth.currentUser?.uid else
            { return }
        let ref = FirebaseManager.FB.storage.reference(withPath: uid)
        guard let data = self.image?.jpegData(compressionQuality: 0.5) else
            { return }
        ref.putData(data) { metaData, error in
            if let error = error{
                self.loginStatus = "failed to upload img to storage: \(error)"
                return
            }

            ref.downloadURL { url, error in
                if let error = error{
                    self.loginStatus = "failed to retrieve downloadUrl: \(error)"
                    return
                }
                self.loginStatus = "Successfully downloaded url: \(url?.absoluteString ?? "")"
                guard let url = url else{
                    return
                }
                storeUserInfo(profileImageUrl: url)
            }
        }
    }
    
    private func storeUserInfo(profileImageUrl: URL){
        let db = FirebaseManager.FB.db
        guard let uid = FirebaseManager.FB.auth.currentUser?.uid else {
            return
            }
        let userData = ["email": email, "uid": uid, "profileImageUrl": profileImageUrl.absoluteString]
        db.collection("users").document(uid).setData(userData) { err in
            if let err = err {
                print("Error writing document: \(err)")
                self.loginStatus = "Error writing document: \(err)"
            } else {
                print("Success")
                self.loginStatus = "Document successfully written!"
                self.didCompleteLoginProcess()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(didCompleteLoginProcess: {
            
        })
    }
}
