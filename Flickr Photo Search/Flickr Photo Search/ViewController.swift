//
//  ViewController.swift
//  Flickr Photo Search
//
//  Created by Tewodros Mengesha on 21.3.2021.
//

import UIKit

struct FlickrImageResult: Codable {
    let photos : FlickrPagedImageResult?
    let stat: String
}

struct FlickrPagedImageResult: Codable {
    let photo : [FlickrURLs]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
}

struct FlickrURLs: Codable {
    let id : String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
}

let apiKey = "b59eaa142fbb03d0ba6c93882fd62e30"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }
    
    func fetchPhotos() {

        let ulrString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=cat&format=json&nojsoncallback=1"
        
        guard let url = URL(string: ulrString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let flickrPhotos = try JSONDecoder().decode(FlickrImageResult.self, from: data)
                print(flickrPhotos)
            }
            catch {
                print(error)
            }
        }
        task.resume()
        
    }


}

