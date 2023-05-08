//
//  ChattingRoomView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/07.
//

import SwiftUI

struct ChattingView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    @State var chat: String = ""
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                scrollView
                ZStack {
                    Color.green.opacity(0.11)
                    HStack {
                        TextField("Chatting~~", text: $chat)
                            .frame(width: proxy.size.width/3*2, height: proxy.size.height/20)
                            .padding(.leading)
                        Image(systemName: "paperplane")
                            .padding(.trailing)
                            .onTapGesture {
                                fireStoreManager.saveData(message: $chat.wrappedValue, name: "Root")
                                chat = ""
                            }
                    }
                }
                .frame(width: proxy.size.width/3*2, height: proxy.size.height/20)
            }
        }
    }
    
    var scrollView: some View {
        ScrollView {
            ForEach(fireStoreManager.chatData, id: \.self) { chat in
                HStack(alignment: .bottom) {
                    if chat.name != "system" {
                        Spacer()
                    }
                    if chat.name != "system" {
                        Text(changeDate(date: chat.date!))
                            .fontWeight(Font.Weight.light)
                            .font(Font.footnote)
                            .frame(height: 40, alignment: .bottom)
                    }
                        if chat.name == "system" {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .padding(.trailing, 5)
                                .padding(.bottom, 20)
                        }
                    VStack(alignment: .leading) {
                        if chat.name == "system" {
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
                                    print(chat.date)
                                    if let date = chat.date {
                                        fireStoreManager.deleteData(date: date)
                                        fireStoreManager.fetchData()
                                    }
                                }
                                Text("Menu Item 2")
                                Text("Menu Item 3")
                            }
                            
                    }
                    if chat.name == "system" {
                        Text(changeDate(date: chat.date!))
                            .fontWeight(Font.Weight.light)
                            .font(Font.footnote)
                            .frame(alignment: .bottom)
                    }
                    if chat.name == "system" {
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
        }
        .listStyle(.inset)
        .listRowSeparator(.hidden)
    }
    
    private func changeDate(date: String) -> String {
        let pattern = "\\d{2}:\\d{2}"
        var result = date.range(of: pattern, options: .regularExpression)!
        
        return String(date[result])
    }
}


struct ChattingView_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView()
            .environmentObject(FireStoreManager())
    }
}

