//
//  SellCellView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/15/24.
//

import SwiftUI
import Kingfisher

struct SellCellView: View {
    let product: Product
    let status: ProductStatus
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                // 일자
                Text(formatDate(product.createdAt))
                    .font(.pretendardMedium12)
                    .foregroundStyle(Color.unselected_tab)
                
                Spacer()
                
                // 상태
                Text(getStatusText())
                    .font(.pretendardBold12)
                    .padding(.vertical, 4)
                    .modifier(StatusStyleModifier(status: status))
                    .fixedSize()
            }
            
            HStack(spacing: 10) {
                // 상품 이미지
                KFImage(URL(string: product.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 94, height: 94)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                
                VStack(alignment: .leading, spacing: 4) {
                    // 상품명
                    Text(product.product)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .font(.pretendardSemiBold16)
                    // 카테고리명
                    Text(product.productCategory)
                        .font(.pretendardMedium12)
                    
                    HStack(alignment: .bottom) {
                        // 플랫폼명
                        Text(product.company.joined(separator: ", "))
                            .font(.pretendardMedium12)
                            .foregroundStyle(.unselected)
                        
                        Spacer()
                        
                        // 가격
                        Text("\(formatPrice(product.price))원")
                            .font(.pretendardSemiBold16)
                    }
                }
            }
        }
        //        .padding(.horizontal, 16)
        .padding(16)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
    
    private func getStatusText() -> String {
        switch status {
        case .selling:
            return "판매중"
        case .soldOut:
            return "판매완료"
        case .failed:
            return "판매실패"
        }
    }
    
    private func formatPrice(_ price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}

struct StatusStyleModifier: ViewModifier {
    let status: ProductStatus
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(foregroundColor)
            .padding(.vertical, 4)
            .padding(.horizontal, 17)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
    
    private var foregroundColor: Color {
        switch status {
        case .selling:
            return .main_Green
        case .soldOut, .failed:
            return .white
        }
    }
    
    private var backgroundColor: Color {
        switch status {
        case .selling:
            return .clear
        case .soldOut:
            return .main_Green
        case .failed:
            return .fail_bg
        }
    }
    
    private var borderColor: Color {
        switch status {
        case .selling, .soldOut:
            return .main_Green
        case .failed:
            return .fail_bg
        }
    }
}



// MARK: - Preview
struct SellCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SellCellView(product: sampleProduct, status: .selling)
                .previewDisplayName("판매중")
            SellCellView(product: sampleProduct, status: .soldOut)
                .previewDisplayName("판매완료")
            SellCellView(product: sampleProduct, status: .failed)
                .previewDisplayName("판매실패")
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var sampleProduct: Product {
        Product(
            productId: 1,
            product: "샘플 제품",
            productCategory: "전자기기",
            imageUrl:"https://i.namu.wiki/i/w11dbZZeomJI4bD3_KItw3vq7tgglcM1YQA_xHULxMsixPpY1S7KcB8WrEFhJNuSuejiiQkicGKMH12JvpUqBQ.webp",
            createdAt: "2024년7월11일",
            company: ["당근마켓", "번개장터"],
            price: 2300000
        )
    }
}
