//
//  Photo.swift
//  TinTint
//
//  Created by Fritz Hsiao on 2025/3/23.
//

import Foundation

struct Photo: Decodable, Identifiable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    var validUrl: String {
        return url.replacingOccurrences(of: "via.placeholder.com", with: "placehold.co") + "/999.png"
    }
}

