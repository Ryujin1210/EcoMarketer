//
//  BoardView2.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/19/24.
//

import SwiftUI

struct BoardView2: View {
    var body: some View {
        VStack {
            Text("글쓰기 힘들고\n글을 올려도 잘 팔리지 않나요?")
                .font(.pretendardBold24)
                .foregroundStyle(Color.main_Green)
                .multilineTextAlignment(.center)
            
            Text("Eco-Marketer는 둥글둥글체, 단호박체, 성냥팔이체 등 다양한 말투를 사용하여\nAI를 통해 구매자의 눈을 사로잡고\n판매율을 높일 수 있는 글을 작성해줍니다.")
                .font(.pretendardMedium16)
                .multilineTextAlignment(.center)
                .padding(.top, 45)
            
            Image("on2")
                .resizable()
                .scaledToFit()
                .padding(.top, 50)

        }
        .padding()

    }
}

#Preview {
    BoardView2()
}
