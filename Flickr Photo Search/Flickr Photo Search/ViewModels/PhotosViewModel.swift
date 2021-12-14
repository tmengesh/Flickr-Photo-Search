//
//  PhotosViewModel.swift
//  Flickr Photo Search
//
//  Created by Tewodros Mengesha on 21.3.2021.
//

import Foundation

class PhotosViewModel {
    
    private var photos: [FlickrURLs] = []
    
    private var networkService = NetworkService()
    
    func numberPhotos() -> Int {
        return photos.count
    }
    
    func photoViewModel(at index: Int) -> PhotoCellViewModel? {
        // Check for out of bounds stuff
        if index > photos.count {
            return nil
        }
        let photo = photos[index]
        return PhotoCellViewModel(urlString: photo.imageURL(), text: photo.title)
    }
    
    func fetchPhotos(with queryText: String, completion: @escaping (() -> Void)) {
        networkService.fetchPhotos(with: queryText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(photos):
                self.photos = photos
            case .failure:
                break
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
