//
//  ChatLogView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 1/3/23.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?
    @State var chatText = ""
    
    var body: some View {
        VStack {
            ScrollView{
                    ForEach(0..<10) { i in
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
                        }.padding(.horizontal)
                            .padding(.top, 8)
                        
                    }
                    HStack{ Spacer() }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
            ChatBar
        }
        .navigationTitle(chatUser?.email ?? "T")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var ChatBar: some View {
        HStack {
            Image(systemName: "gear")
            TextField("Description", text: $chatText)
            Button {
                //
            } label: {
                Text("Send")
                    .background(.blue)
                    .foregroundColor(.white)
            }.padding()

        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: nil)
            
        }
//        MainMessagesView()
    }
}
