//
//  ChattingRoomView.swift
//  Chat2
//
//  Created by 김상호 on 2023/05/07.
//

import SwiftUI

struct ChattingRoomView: View {
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("chatting room name")
                Text("message")
            }
        }
    }
}

struct ChattingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChattingRoomView()
    }
}
