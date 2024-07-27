//
//  WritingLinkView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/17/24.
//

import SwiftUI

struct WritingLinkView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let platforms = ["중고나라", "당근", "번개장터"]
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image("Robot")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            
            Text("어디에 글을 올려볼까요?")
                .font(.pretendardSemiBold20)
            
            ForEach(platforms, id: \.self) { platform in
                Button(action: {
                    openPlatformApp(platform)
                }) {
                    Text("\(platform) 글쓰러가기")
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
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
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
    
    private func openPlatformApp(_ platform: String) {
        var urlString: String
        switch platform {
        case "중고나라":
            urlString = "jnapps3://"
        case "당근":
            urlString = "Karrot://"
        case "번개장터":
            urlString = "bunjang://"
        default:
            return
        }
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        print("Successfully opened \(platform)")
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Failed to open \(platform)")
                    }
                }
            } else {
                // 앱이 설치되어 있지 않은 경우 App Store로 이동
                if let appStoreURL = URL(string: "https://apps.apple.com/search?term=\(platform)") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

struct WritingLinkView_Previews: PreviewProvider {
    static var previews: some View {
        WritingLinkView()
    }
}
