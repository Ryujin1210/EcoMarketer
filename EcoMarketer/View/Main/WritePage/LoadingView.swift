//
//  LoadingView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/16/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image("Robot")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            
            Text("AI가")
                .font(.pretendardBold20)
            HStack(spacing: 0) {
                Text("게시글을 생성")
                    .font(.pretendardBold20)
                    .foregroundStyle(Color.main_Green)
                Text("하고 있어요!")
                    .font(.pretendardBold20)
            }
            Text("잠시만 기다려 주세요!")
                .font(.pretendardMedium14)
            
            ProgressView()
                .padding()
        }
        .padding(.vertical, 24)
    }
}

#Preview {
    LoadingView()
}
