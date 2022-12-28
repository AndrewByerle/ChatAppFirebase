//
//  ContentView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 12/25/22.
//

import SwiftUI

struct AuthView: View {
    @State var isLoginShown = false
    @State var email = ""
    @State var password = ""
    
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
                            print("")
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
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
                }.padding()
            }.navigationTitle(isLoginShown ? "Log in" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.06)).ignoresSafeArea())
        }
    }
    private func handleAction() {
        if isLoginShown{
            print("Log in user")
        } else{
            print("Create account, store user in firestore and image in storage")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
