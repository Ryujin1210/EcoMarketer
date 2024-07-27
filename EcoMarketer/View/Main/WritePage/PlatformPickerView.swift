//
//  PlatformPickerView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/16/24.
//

import SwiftUI

struct PlatformPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedPlatform: String

    let platforms = ["중고나라", "당근", "번개장터"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("플랫폼 선택")
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
            
            VStack(spacing: 8) {
                ForEach(platforms, id: \.self) { platform in
                    Button(action: {
                        selectedPlatform = platform
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(platform)
                            .font(.pretendardBold16)
                            .foregroundStyle(colorForPlatform(platform))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.box_border, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(16)
    }
    
    private func colorForPlatform(_ platform: String) -> Color {
        switch platform {
        case "중고나라":
            return Color.main_Green
        case "당근":
            return Color.carrot_bg
        case "번개장터":
            return Color.thunder_bg
        default:
            return Color.black
        }
    }
}

struct PlatformPickerView_Previews: PreviewProvider {
    @State static var selectedPlatform: String = ""
    
    static var previews: some View {
        PlatformPickerView(selectedPlatform: $selectedPlatform)
    }
}

