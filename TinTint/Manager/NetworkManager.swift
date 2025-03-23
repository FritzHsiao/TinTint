//
//  NetworkManager.swift
//  TinTint
//
//  Created by Fritz Hsiao on 2025/3/23.
//

import Foundation
import RxSwift

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let baseURL = "https://jsonplaceholder.typicode.com/photos?_page=1&_limit=40"
    
    func fetchPhotos(page: Int) -> Observable<[Photo]> {
        var urlComponents = URLComponents(string: baseURL)
         urlComponents?.queryItems = [
            URLQueryItem(name: "_page", value: "\(page)"),
            URLQueryItem(name: "_limit", value: "40")
         ]
        
        guard let url = urlComponents?.url else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        return Observable.create { observer in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    do {
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        observer.onNext(photos)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
