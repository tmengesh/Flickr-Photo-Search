//
//  FlickrPhotoModel.swift
//  Flickr Photo Search
//
//  Created by Tewodros Mengesha on 21.3.2021.
//

import Foundation

struct FlickrImageResult: Codable {
    let photos: FlickrPagedImageResult?
    let stat: String
}

struct FlickrPagedImageResult: Codable {
    let photo: [FlickrURLs]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
}

struct FlickrURLs: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    func imageURL() -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
