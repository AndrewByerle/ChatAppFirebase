//
//  MainMessagesView.swift
//  ChatAppFirebase
//
//  Created by Andrew Byerle on 12/31/22.
//

import SwiftUI

struct MainMessagesView: View {
    @State var isLogoutOptionShown = false
    
    
    var body: some View {
        NavigationView{
            VStack {
                // nav bar
                HStack(spacing: 20) {
                    Image(systemName: "person.fill").font(.system(size: 24, weight: .heavy))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("USERNAME")
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
                ScrollView{
                    ForEach(0..<10, id: \.self){ num in
                        VStack {
                            HStack(spacing: 16){
                                Image(systemName: "person.fill")
                                    .font(.system(size: 30))
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.black, lineWidth: 1))
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
            .overlay(
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
                }, alignment: .bottom
            )
            .navigationBarHidden(true)
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
