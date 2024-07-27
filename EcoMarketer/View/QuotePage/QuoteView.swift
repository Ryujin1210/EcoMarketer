//
//  QuoteView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import SwiftUI

struct ProductDummy: Identifiable {
    let id = UUID()
    let product: String
    let productCategory: String
    let price: Int
    let tags: [String]
}

struct QuoteView: View {
    let dummyProducts: [ProductDummy] = [
        ProductDummy(product: "에코 친화적 물병", productCategory: "생활용품", price: 15000, tags: ["중고나라"]),
        ProductDummy(product: "재활용 노트북", productCategory: "전자제품", price: 500000, tags: ["당근"]),
        ProductDummy(product: "유기농 티셔츠", productCategory: "의류", price: 25000, tags: ["번개장터"]),
        ProductDummy(product: "태양광 충전기", productCategory: "전자제품", price: 35000, tags: ["중고나라", "당근"]),
        ProductDummy(product: "친환경 세제", productCategory: "생활용품", price: 8000, tags: ["당근", "번개장터"]),
        ProductDummy(product: "재생 종이 노트", productCategory: "문구", price: 5000, tags: ["번개장터", "중고나라"]),
        ProductDummy(product: "대나무 칫솔", productCategory: "생활용품", price: 3000, tags: ["중고나라", "당근", "번개장터"]),
        ProductDummy(product: "유리 빨대", productCategory: "주방용품", price: 7000, tags: ["당근"]),
        ProductDummy(product: "천연 비누", productCategory: "뷰티", price: 6000, tags: ["번개장터"]),
        ProductDummy(product: "재활용 플라스틱 화분", productCategory: "홈/가든", price: 12000, tags: ["중고나라"])
    ]
    
    @State private var dummySearch: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("오늘의 시세 📊")
                    .font(.pretendardBold32)
                Text("나의 물건의 시세가 궁금하신가요? \n지금 바로 검색해보세요!")
                    .font(.pretendardMedium16)
            }
            
            HStack {
                TextField("제품 이름을 입력해주세요", text: $dummySearch)
                    .font(.pretendardMedium16)
                    .padding(.vertical, 12)
                    .padding(.leading, 12)
                
                Button(action: {
                    // 검색 액션
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.unselected_tab)
                        .padding(14)
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.box_border, lineWidth: 1)
            )
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<dummyProducts.count, id: \.self) { index in
                        productRow(for: dummyProducts[index])
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal ,16)
        .padding(.top, 24)
    }
    
    
    private func productRow(for product: ProductDummy) -> some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 94, height: 94)
                    .background(Color.box_border)
                    .cornerRadius(8)
                
                HStack(spacing: 2) {
                    ForEach(product.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 8))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(colorForTag(tag))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                .padding(4)
                .offset(x: -4, y: -4) // 태그를 왼쪽 상단으로 약간 이동
            }
            .overlay(
                HStack(spacing: 2) {
                    ForEach(product.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 8))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(colorForTag(tag))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                .padding(4)
                .offset(x: -4, y: -4), // 태그를 왼쪽 상단으로 약간 이동
                alignment: .topLeading
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.product)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .font(.pretendardMedium16)
                Text(product.productCategory)
                    .font(.pretendardMedium12)
                    .foregroundStyle(Color.unselected_tab)
                
                HStack(alignment: .bottom) {
                    Text("\(product.price)원")
                        .font(.pretendardSemiBold16)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
    }
    private func colorForTag(_ tag: String) -> Color {
        switch tag {
        case "중고나라":
            return .main_Green
        case "당근":
            return .carrot_bg
        case "번개장터":
            return .thunder_bg
        default:
            return .gray
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
