//
//  ContentView.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
