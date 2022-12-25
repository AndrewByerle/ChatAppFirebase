//
//  ContentView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @State var isLoginShown = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                Picker("AuthType", selection: $isLoginShown) {
                    Text("Login").tag(false)
                    Text("Create Account").tag(true)
                }.pickerStyle(SegmentedPickerStyle())
                 .padding()
                Button {
                    print("")
                } label: {
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                }
                TextField("Email", text: $email)
                TextField("Password", text: $password)
                Button {
                } label: {
                    HStack{
                        Spacer()
                        Text("Create Acct")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                        Spacer()
                    }.background(Color.blue)
                }

            }.navigationTitle("Create Account")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
