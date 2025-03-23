//
//  Untitled.swift
//  TinTint
//
//  Created by Fritz Hsiao on 2025/3/23.
//

import Foundation
import RxSwift

class PhotosViewModel: ObservableObject {
    
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var hasMoreData = true
    private var currentPage = 1
    private let disposeBag = DisposeBag()
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        
        NetworkManager.shared.fetchPhotos(page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] photos in
                self?.isLoading = false
                if photos.isEmpty {
                    self?.hasMoreData = false
                } else {
//                    self?.photos = photos.map { photo in
//                        if let url = URL(string :photo.thumbnailUrl) {
//                            var updatedPhoto = photo
//                            updatedPhoto.thumbnailUrl = self?.isValidURL(url) ?? false ? photo.thumbnailUrl : photo.validUrl
//                            return updatedPhoto
//                        } else {
//                            return photo
//                        }
//                    }
                    
                    let updatedPhotos = photos.map { photo in
                        var updatedPhoto = photo
                        if let url = URL(string: photo.thumbnailUrl),
                           !self!.isValidURL(url) {
                            updatedPhoto.thumbnailUrl = photo.validUrl // Use fallback URL if the original URL is invalid
                        }
                        return updatedPhoto
                    }
                    self?.photos.append(contentsOf: updatedPhotos)
                    self?.currentPage += 1 //
                }
            }, onError: { error in
                print("Error fetching photos: \(error)")
            })
            .disposed(by: disposeBag)
    }
   
    private func isValidURL(_ url: URL) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isValid = false
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error checking URL: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse {
                isValid = (httpResponse.statusCode == 200)
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return isValid
    }

}
