//
//  BoardView3.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/19/24.
//

import SwiftUI

struct BoardView3: View {
    var body: some View {
        VStack {
            Text("왜 이 플랫폼만\n물건이 안 팔릴까요?")
                .font(.pretendardBold24)
                .foregroundStyle(Color.main_Green)
                .multilineTextAlignment(.center)
            
            Text("플랫폼 마다 선호하는 느낌이 달라요!\nEco-Marketer가 다 분석해 놨으니\n더 효과적인 중고거래를 시작해보세요.\n")
                .font(.pretendardMedium16)
                .multilineTextAlignment(.center)
                .padding(.top, 45)
            
            Image("on3")
                .resizable()
                .scaledToFit()
                .padding(.top, 50)

            
        }
        .padding()

    }
}

#Preview {
    BoardView3()
}
