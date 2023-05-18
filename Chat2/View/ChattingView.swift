//
//  ChattingRoomView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/07.
//

import SwiftUI
import Combine

struct ChattingView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    @EnvironmentObject var authManager: AuthManager
    @State var chat: String = ""
    @State var keyboardHeight: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                scrollView
                Group {
                    HStack {
                        TextField("Chatting~~", text: $chat)
                            .padding(.leading)
                            .padding(.vertical, 10)
                            .frame(width: proxy.size.width/3*2)

                        Image(systemName: "paperplane")
                            .padding(.trailing)
                            .onTapGesture {
                                fireStoreManager.saveData(message: $chat.wrappedValue, name: authManager.userName, uid: authManager.currentUser?.uid ?? "")
                                chat = ""
                            }
                    }
                }
                .background(Color.gray.opacity(0.11))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: proxy.size.width/3*2, height: proxy.size.height/20)
                Rectangle().foregroundColor(Color.white).frame(height: 10)
            }
        }
    }
    
    var scrollView: some View {
        ScrollView {
            ForEach(fireStoreManager.chatData, id: \.self) { chat in
                HStack(alignment: .bottom) {
                    if chat.uid == authManager.currentUser?.uid ?? "" {
                        Spacer()
                    }
                    if chat.uid == authManager.currentUser?.uid ?? "" {
                        Text(changeDate(date: chat.date!))
                            .fontWeight(Font.Weight.light)
                            .font(Font.footnote)
                            .frame(height: 40, alignment: .bottom)
                    }
                    if chat.uid != authManager.currentUser?.uid ?? "" {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .padding(.trailing, 5)
                                .padding(.bottom, 20)
                        }
                    VStack(alignment: .leading) {
                        if chat.uid != authManager.currentUser?.uid ?? "" {
                            Text(chat.name)
                                .fontWeight(Font.Weight.light)
                                .font(Font.footnote)
                                .fixedSize()
                        }
                        Text(chat.message)
                            .fontWeight(Font.Weight.light)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .contextMenu {
                                Button("Delete") {
                                    print(chat.date ?? "nil")
                                    if let date = chat.date {
                                        fireStoreManager.deleteData(date: date)
                                    }
                                }
                            }
                            
                    }
                    if chat.uid != authManager.currentUser?.uid ?? "" {
                        Text(changeDate(date: chat.date!))
                            .fontWeight(Font.Weight.light)
                            .font(Font.footnote)
                            .frame(alignment: .bottom)
                    }
                    if chat.uid != authManager.currentUser?.uid ?? "" {
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .listStyle(.inset)
        .listRowSeparator(.hidden)
    }
    
    private func changeDate(date: String) -> String {
        let pattern = "\\d{2}:\\d{2}"
        let result = date.range(of: pattern, options: .regularExpression)!
        
        return String(date[result])
    }
}

struct ChattingView_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView()
            .environmentObject(FireStoreManager())
            .environmentObject(AuthManager())
    }
}

