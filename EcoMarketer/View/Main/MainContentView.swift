//
//  MainContentView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/13/24.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var userStatsViewModel: UserStatsViewModel
    @State private var isWriteViewPresented = false
    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            topSection
            bottomSection
            Spacer()
        }
        .padding(16)
        .background(Color.background_Color)
        .onAppear {
            userStatsViewModel.fetchAllData()
        }
        .fullScreenCover(isPresented: $isWriteViewPresented) {
            WriteView()
        }
    }
    
    private var topSection: some View {
        VStack(spacing: 0) {
            tradeCountInfo
            
            Image("Lv\(userStatsViewModel.levelInfo?.myLevel ?? 1)")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 80)
                .padding(.top, 45)
                .padding(.vertical, 4)
            
            Text("더 참여하여 나무를 키워주세요!")
                .font(.pretendardMedium14)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private var tradeCountInfo: some View {
        VStack(spacing: 0) {
            HStack {
                Text("물건 거래 횟수")
                    .font(.pretendardBold20)
                
                Text("\(userStatsViewModel.tradeCount)번")
                    .font(.pretendardBold24)
                    .foregroundStyle(.mainGreen)
                Text("만큼")
                    .font(.pretendardBold20)
            }
            Text("탄소 절감에 기여했어요!")
                .font(.pretendardBold20)
        }
    }
    
    private var bottomSection: some View {
        VStack {
            levelInfo
            
            Text("에코 포인트로 등급을 올려 환경 지킴 레벨을 올려요!")
                .font(.pretendardMedium12)
                .multilineTextAlignment(.center)
                .padding(.vertical, 16)
            
            writeButton
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private var levelInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("나의 환경 지킴 레벨 🌱")
                    .font(.pretendardBold20)
                
                Spacer()
                
                Text("\(userStatsViewModel.levelInfo?.myLevelExperience ?? 0)")
                    .font(.pretendardBold32)
                    .foregroundStyle(.mainGreen)
                Text("/")
                    .font(.pretendardBold20)
                Text("\(userStatsViewModel.levelInfo?.levelExperience ?? 0)P")
                    .font(.pretendardBold20)
            }
            
            Text("Level \(userStatsViewModel.levelInfo?.myLevel ?? 1)")
            
            ProgressView(value: userStatsViewModel.calculateProgress())
                .accentColor(.mainGreen)
                .scaleEffect(x: 1, y: 2.5, anchor: .center)
                .animation(.interactiveSpring(duration: 0.5), value: userStatsViewModel.calculateProgress())
        }
    }
    
    private var writeButton: some View {
        Button(action: {
            // AI 글 작성하러 가기
            isWriteViewPresented = true
        }) {
            Text("AI와 함께 새로운 글 작성하기")
                .font(.pretendardSemiBold16)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(.white)
                .background(Color.mainGreen)
                .cornerRadius(8)
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView(userStatsViewModel: UserStatsViewModel())
    }
}
