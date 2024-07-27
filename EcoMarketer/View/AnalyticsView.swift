//
//  AnalyticsView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import SwiftUI

struct AnalyticsView: View {
    @State var dummyGraphShow: Bool = false
    var body: some View {
        ZStack {
            ScrollView {
                Image("Analystics")
                    .resizable()
                    .scaledToFill()
            }
            .onTapGesture {
                dummyGraphShow.toggle()
            }
            .sheet(isPresented: $dummyGraphShow) {
                Image("dummySheet")
                    .resizable()
                    .scaledToFill()
                    .presentationDetents([.height(560)]) // 높이를 250으로 설정
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
