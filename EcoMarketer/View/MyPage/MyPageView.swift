//
//  MyPageView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var userStatsViewModel: UserStatsViewModel
    @StateObject private var myPageViewModel = MyPageViewModel()
    @State private var selection = 0
    
    private let items = ["판매중", "판매완료", "판매실패"]
    
    var body: some View {
        VStack{
            userSection
            sellSection
        }
        .onAppear {
            myPageViewModel.fetchAllProducts()
        }
    }
    
    private var userSection: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .bottom) {
                        Text("\(userStatsViewModel.userName)")
                            .font(.pretendardBold32)
                        Text("님!")
                            .font(.pretendardBold24)
                    }
                    Text("오늘도 즐거운 거래 하시길 바래요!")
                        .font(.pretendardMedium16)
                }
                
                Spacer()
                
                VStack {
                    Button {
//                        loginViewModel.logout()
                        loginViewModel.logoutFromOurServer()
                    } label: {
                        Text("로그아웃")
                            .font(.pretendardMedium12)
                            .foregroundStyle(.black)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(Color.logout_bg)
                            .cornerRadius(99)
                    }
                    
                }
            }
            .padding(.top, 24)
            
            HStack {
                Text("나의 판매 내역")
                    .font(.pretendardBold20)
                
                Spacer()
            }
            .padding(.top, 26)
        }
        .padding(.horizontal, 16)
        
    }
    
    private var sellSection: some View {
        VStack(spacing: 0) {
            CustomTabBar(selection: $selection, items: items)
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ProductListView(myPageViewModel: myPageViewModel, products: myPageViewModel.sellingProducts, status: .selling)
                        .frame(width: geometry.size.width)
                        .opacity(selection == 0 ? 1 : 0)
                    
                    ProductListView(myPageViewModel: myPageViewModel, products: myPageViewModel.soldOutProducts, status: .soldOut)
                        .frame(width: geometry.size.width)
                        .opacity(selection == 1 ? 1 : 0)

                    ProductListView(myPageViewModel: myPageViewModel, products: myPageViewModel.failedProducts, status: .failed)
                        .frame(width: geometry.size.width)
                        .opacity(selection == 2 ? 1 : 0)

                }
                .offset(x: -CGFloat(selection) * geometry.size.width)
                .animation(.easeInOut, value: selection)
            }
        }
        .padding(.top, 12)
    }
    
}

#Preview {
    MyPageView(loginViewModel: LoginViewModel(), userStatsViewModel: UserStatsViewModel())
}


