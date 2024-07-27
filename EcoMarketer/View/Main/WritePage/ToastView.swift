//
//  ToastView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/17/24.
//

import SwiftUI

struct ToastView: View {
    let message: String = "클립보드에 복사되었습니다!"
    
    var body: some View {
        Text(message)
            .font(.pretendardSemiBold17)
            .padding()
            .background(Color.main_Green)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview {
    ToastView()
}
