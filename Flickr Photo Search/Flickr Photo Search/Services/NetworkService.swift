//
//  NetworkService.swift
//  Flickr Photo Search
//
//  Created by Tewodros Mengesha on 21.3.2021.
//

import Foundation
import UIKit

enum FlickError: Error {
    case badFormat
    case serverError
    case userError
    case badRequest
}

class NetworkService {
    private let apiKey = "b59eaa142fbb03d0ba6c93882fd62e30"

    func fetchPhotos(with queryText: String, completion: @escaping (Result<[FlickrURLs], FlickError>) -> Void) {
        let escapedTag = queryText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? queryText.components(separatedBy: " ").first ?? "Dog"
        let ulrString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTag)&format=json&nojsoncallback=1"
        guard let url = URL(string: ulrString) else {
            completion(.failure(.badRequest))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                let flickrPhotos = try JSONDecoder().decode(FlickrImageResult.self, from: data)
                if let photos = flickrPhotos.photos?.photo {
                    completion(.success(photos))
                    return
                } else {
                    completion(.success([]))
                    return
                }
            }
            catch {
                completion(.failure(.badFormat))
            }
        }.resume()
    }
    
    func getImage(from url: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}
