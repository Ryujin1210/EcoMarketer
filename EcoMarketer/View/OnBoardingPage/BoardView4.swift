//
//  BoardView4.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/19/24.
//

import SwiftUI

struct BoardView4: View {
    var body: some View {
        VStack {
            Text("애증이 담긴 물건\n가격 측정 어렵죠?")
                .font(.pretendardBold24)
                .foregroundStyle(Color.main_Green)
                .multilineTextAlignment(.center)
            
            Text("Eco-Marketer가\n객관적인 시세를 알아볼 수 있도록 했습니다.\n여러 플랫폼의 가격을 검색하여\n같거나 비슷한 물건의 시세를\n빠르게 하눈에 볼 수 있어요!")
                .font(.pretendardMedium16)
                .multilineTextAlignment(.center)
                .padding(.top, 45)
            
            Image("on4")
                .resizable()
                .scaledToFit()
                .padding(.top, 50)

            
        }
        .padding()

    }
}

#Preview {
    BoardView4()
}
