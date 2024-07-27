//
//  BoardView1.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/19/24.
//

import SwiftUI

struct BoardView1: View {
    var body: some View {
        VStack {
            Text("중고거래 글 작성에도\n비법이 있다는거 아시나요?")
                .font(.pretendardBold24)
                .foregroundStyle(Color.main_Green)
                .multilineTextAlignment(.center)
            
            Text("Eco-Marketer가 다양한 말투로\n알아서 만들어 드립니다.\n시세와 플랫폼 분석까지 한 번에 조사하실 필요없이\n간편히 사용해보세요.")
                .font(.pretendardMedium16)
                .multilineTextAlignment(.center)
                .padding(.top, 45)
            
            Image("on1")
                .resizable()
                .scaledToFit()
                .padding(.top, 50)
            
        }
        .padding()
    }
}

#Preview {
    BoardView1()
}
