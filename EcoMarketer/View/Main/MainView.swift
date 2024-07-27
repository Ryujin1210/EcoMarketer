//
//  MainView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject private var userStatsViewModel = UserStatsViewModel()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        
        // UITabBar appearance 수정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Border 추가
        appearance.shadowImage = UIImage() // 기본 그림자 제거
        appearance.shadowColor = UIColor(Color.unselected_tab) // Border 색상
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.unselected_tab)
        
    }
    
    var body: some View {
        NavigationView {
            TabView {
                
                MainContentView(userStatsViewModel: userStatsViewModel)
                    .tabItem {
                        Image(systemName: "leaf.fill")
                        Text("메인")
                    }
                
                
                AnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("통계")
                    }
                
                QuoteView()
                    .tabItem {
                        Image(systemName: "scalemass.fill")
                        Text("시세")
                    }
                
                MyPageView(loginViewModel: loginViewModel, userStatsViewModel: userStatsViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("마이페이지")
                    }
                
            }
            .accentColor(.mainGreen)
            
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(loginViewModel: LoginViewModel())
}
