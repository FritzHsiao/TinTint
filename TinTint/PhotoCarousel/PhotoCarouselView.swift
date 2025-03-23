//
//  PhotoCarouselView.swift
//  TinTint
//
//  Created by Fritz Hsiao on 2025/3/23.
//

import SwiftUI

struct PhotoCarouselView: View {
    @StateObject private var viewModel = PhotosViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.photos) { photo in
                        VStack {
                            Text(String(photo.id))
                            Text(photo.title)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 80, height: 80)
                        .background (
                            AsyncImage(url: URL(string: photo.thumbnailUrl)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure(_), .empty:
                                    Color.gray
                                @unknown default:
                                    Color.gray
                                }
                            }
                                .frame(width: 80, height: 80)
                        )
                        .onAppear {
                            if let lastItem = viewModel.photos.last {
                                if photo.id == lastItem.id {
                                    viewModel.fetchPhotos()
                                }
                            }
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading more photos...")
                        .padding()
                }
                
                if !viewModel.hasMoreData {
                    Text("No more photos")
                        .padding()
                }
            }
            .navigationTitle("Photos")
        }
    }
}

#Preview {
    PhotoCarouselView()
}
