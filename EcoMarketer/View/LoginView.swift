//
//  LoginView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/9/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if loginViewModel.isLoggedIn {
                    NavigationLink(destination: MainView(loginViewModel: loginViewModel), isActive: $loginViewModel.isLoggedIn) {
                        EmptyView()
                    }.hidden()
                } else{
                    ZStack{
                        Image("Login_comment")
                            .padding(.bottom, 36)
                            .padding(.leading, 135)
                        Image("WritingLogo")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 50)
                    }
                    
                    Text("AI를 통해 간편하게 글 작성하고 \n한 눈에 보이는 시세와 플렛폼 통계를 확인해요")
                        .multilineTextAlignment(.center)
                        .font(.pretendardMedium16)
                    
                    Spacer()
                    
                    Text("간편하게 로그인하여 시작해보아요!")
                        .font(.pretendardBold16)
                        .foregroundStyle(.textGreen)
                        .padding(.bottom, 30)
                    Button{
                        loginViewModel.loginWithKakao()
                    } label: {
                        Image("Kakao_Button")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 40)
                            .padding(.bottom, 60)
                    }
                    
                    
                }
            }
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    LoginView()
}
