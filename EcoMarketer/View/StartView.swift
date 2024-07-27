//
//  StartView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/7/24.
//
import SwiftUI

struct StartView: View {
    
    @State private var isLaunchScreenViewPresented = true
    
    var body: some View {
        if !isLaunchScreenViewPresented {
            if isFirstLaunch() {
                OnBoardingView()
            } else {
                LoginView()
            }
        } else {
            LaunchScreen(isPresented: $isLaunchScreenViewPresented)
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
        return !isFirstLaunch
    }
}

#Preview {
    StartView()
}
