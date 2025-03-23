//
//  ContentView.swift
//  TinTint
//
//  Created by Fritz Hsiao on 2025/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    PhotoCarouselView()
                } label: {
                    Text("Photo Carousel")
                        .font(.largeTitle)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
