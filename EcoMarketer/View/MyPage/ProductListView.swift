//
//  ProductListView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/15/24.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    let products: [Product]
    let status: ProductStatus
    
    var body: some View {
        List {
            ForEach(products.sorted(by: { $0.productId > $1.productId })) { product in
                if status == .selling {
                    swipableSellCellView(for: product)
                } else {
                    SellCellView(product: product, status: status)
                }
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder
    private func swipableSellCellView(for product: Product) -> some View {
        SellCellView(product: product, status: .selling)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(action: {
                    myPageViewModel.patchStatus(productId: product.productId, status: .soldOut)
                }) {
                    Label("판매 완료", systemImage: "checkmark.circle")
                }
                .tint(.main_Green)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button(action: {
                    myPageViewModel.patchStatus(productId: product.productId, status: .failed)
                }) {
                    Label("판매 실패", systemImage: "x.circle")
                }
                .tint(.red)
            }
    }
}

#Preview {
    let mockViewModel = MyPageViewModel()
    return ProductListView(
        myPageViewModel: mockViewModel,
        products: [
            Product(
                productId: 1,
                product: "에코 물병",
                productCategory: "생활용품",
                imageUrl: "https://example.com/eco-bottle.jpg",
                createdAt: "2024-07-15T10:00:00Z",
                company: ["에코컴퍼니"],
                price: 15000,
                status: .selling
            ),
            Product(
                productId: 2,
                product: "재활용 노트북",
                productCategory: "전자제품",
                imageUrl: "https://example.com/recycled-laptop.jpg",
                createdAt: "2024-07-14T09:30:00Z",
                company: ["그린테크"],
                price: 800000,
                status: .soldOut
            ),
            Product(
                productId: 3,
                product: "유기농 티셔츠",
                productCategory: "의류",
                imageUrl: "https://example.com/organic-tshirt.jpg",
                createdAt: "2024-07-13T14:15:00Z",
                company: ["에코패션", "오가닉웨어"],
                price: 35000,
                status: .failed
            )
        ],
        status: .selling
    )
}
