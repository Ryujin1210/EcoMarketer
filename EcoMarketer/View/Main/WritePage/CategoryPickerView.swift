//
//  CategoryPickerView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/16/24.
//

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCategory: String
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)
    let categoryItems = ["디지털기기", "티켓/교환권", "여성패션/잡화", "남성패션/잡화", "생활가전", "생활주방", "스포츠/레저", "취미/게임/음반", "뷰티/미용", "식물", "가공식품", "건강기능식품", "반려동물용품", "도서", "기타중고"]
    
    // 카테고리별 이미지 이름 매핑
    let categoryImages: [String: String] = [
        "디지털기기": "digital_device",
        "티켓/교환권": "ticket",
        "여성패션/잡화": "women_fashion",
        "남성패션/잡화": "men_fashion",
        "생활가전": "home_appliance",
        "생활주방": "kitchen",
        "스포츠/레저": "sports",
        "취미/게임/음반": "hobby",
        "뷰티/미용": "beauty",
        "식물": "plant",
        "가공식품": "processed_food",
        "건강기능식품": "health_food",
        "반려동물용품": "pet",
        "도서": "book",
        "기타중고": "etc"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("카테고리")
                    .font(.pretendardSemiBold20)
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.unselected_tab)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.bottom, 12)
            
            // 카테고리 gridSection
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categoryItems, id: \.self) { item in
                    CategoryItemView(category: item, isSelected: selectedCategory == item, imageName: categoryImages[item]!)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedCategory = item
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                }
            }
        }
        .padding(22.5)
    }
}

struct CategoryItemView: View {
    let category: String
    let isSelected: Bool
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
            
            Text(category)
                .font(.pretendardMedium12)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(11)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.main_Green : Color.box_border, lineWidth: isSelected ? 2 : 1)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(), value: isSelected)
    }
}


struct CategoryPickerView_Previews: PreviewProvider {
    @State static var selectedCategory: String = ""
    
    static var previews: some View {
        CategoryPickerView(selectedCategory: $selectedCategory)
    }
}
