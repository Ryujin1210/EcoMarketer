//
//  EcoMarketerApp.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/7/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct EcoMarketerApp: App {
    let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""

    init() {
            // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: nativeAppKey as! String)
        }
    
    var body: some Scene {
        WindowGroup {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            StartView().onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
