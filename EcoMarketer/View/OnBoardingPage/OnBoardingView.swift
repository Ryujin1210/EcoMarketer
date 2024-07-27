//
//  OnBoardingView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/9/24.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    BoardView1()
                    BoardView2()
                    BoardView3()
                    BoardView4()
                    BoardView5()
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                
                NavigationLink(destination: LoginView()) {
                    Text("바로 시작하기")
                        .font(.pretendardSemiBold17)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.main_Green)
                        .multilineTextAlignment(.center)
                }
                
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    OnBoardingView()
}
