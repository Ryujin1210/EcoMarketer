//
//  BoardView5.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/19/24.
//

import SwiftUI

struct BoardView5: View {
    var body: some View {
        VStack {
            Text("중고 거래가 지구에\n큰 도움이 된다는 걸 아시나요?")
                .font(.pretendardBold24)
                .foregroundStyle(Color.main_Green)
                .multilineTextAlignment(.center)
            
            Text("판매 횟수와 탄소 절감 기여도에 따라\n레벨이 증가하고 테마가 변해요!\n중고 거래를 통해 다양한 테마도 보고\n탄소 절감도 도와봐요!")
                .font(.pretendardMedium16)
                .multilineTextAlignment(.center)
                .padding(.top, 45)
            
            Image("on5")
                .resizable()
                .scaledToFit()
                .padding(.top, 50)

            
        }
        .padding()

    }
}

#Preview {
    BoardView5()
}
