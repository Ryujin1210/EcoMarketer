//
//  CustomTabBar.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/13/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selection: Int
    let items: [String]
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<items.count, id: \.self) { index in
                        TabItem(title: items[index],
                                isSelected: selection == index,
                                namespace: namespace,
                                width: geometry.size.width / CGFloat(items.count))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
                                selection = index
                            }
                        }
                    }
                }
            }
            .frame(height: 40)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 0.7)  // 얇은 회색선
        }
    }
}

private struct TabItem: View {
    let title: String
    let isSelected: Bool
    var namespace: Namespace.ID
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.pretendardBold16)
                .foregroundColor(isSelected ? .black : .secondary)
                .frame(width: width, height: 39)
            
            ZStack {
                if isSelected {
                    Rectangle()
                        .fill(Color.black)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                }
            }
            .frame(width: width, height: 1.5)
        }
    }
}

struct CustomTabBarPreview: View {
    @State private var selection = 0
    
    var body: some View {
        CustomTabBar(selection: $selection, items: ["판매중", "판매실패", "판매완료"])
    }
}

#Preview {
    CustomTabBarPreview()
}
