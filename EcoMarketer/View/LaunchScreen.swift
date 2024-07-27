//
//  LaunchScreen.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/7/24.
//

import SwiftUI

struct LaunchScreen: View {
    
    @Binding var isPresented: Bool
    
    @State private var scale = CGSize(width: 0.8, height: 0.8)
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("CircleLogo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 67)
            
            Spacer()
            
            Image("WritingLogo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 125)
        }
        .scaleEffect(scale)
        .ignoresSafeArea()
        .onAppear{
            withAnimation(.easeInOut(duration: 1.5)) {
                scale = CGSize(width: 1, height: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPresented.toggle()
                }
            })
        }
    }
}

#Preview {
    LaunchScreen(isPresented: .constant(true))
}
