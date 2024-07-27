//
//  ConceptPickerView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/16/24.
//

import SwiftUI

struct ConceptPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedConcept: String
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)
    let concepetItems = ["당근100도체", "둥글둥글체", "단호박체", "성냥팔이체", "귀욤체", "궁서체", "요점만체"]
    
    // 카테고리별 이미지 이름 매핑
    let conceptImages: [String: String] = [
        "당근100도체": "carrot100",
        "둥글둥글체": "circlefont",
        "단호박체": "pumkinfont",
        "성냥팔이체": "poorfont",
        "귀욤체": "cutefont",
        "궁서체": "hardfont",
        "요점만체": "skipfont",
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("판매 컨셉")
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
                ForEach(concepetItems, id: \.self) { item in
                    ConceptItemView(concept: item, isSelected: selectedConcept == item, imageName: conceptImages[item]!)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedConcept = item
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

struct ConceptItemView: View {
    let concept: String
    let isSelected: Bool
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
            
            Text(concept)
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


struct ConceptPickerView_Previews: PreviewProvider {
    @State static var selectedConcept: String = ""
    
    static var previews: some View {
        ConceptPickerView(selectedConcept: $selectedConcept)
    }
}
