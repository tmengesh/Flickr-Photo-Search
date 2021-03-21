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

class ViewController: UIViewController {
    
    let apiKey = "b59eaa142fbb03d0ba6c93882fd62e30"
    var photos : [FlickrURLs] = []
    
    private var collectionView: UICollectionView?
    let searchBar = UISearchBar()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/3, height: view.frame.size.width/2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
    /*
     Flickr Image url format
    https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
     */
    
    func generateFlickrImageURL(farm : String , server: String, id: String, secret: String ) -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    func fetchPhotos(query: String) {
        
        let ulrString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(query)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: ulrString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let flickrPhotos = try JSONDecoder().decode(FlickrImageResult.self, from: data)
                DispatchQueue.main.async {
                    self?.photos = flickrPhotos.photos!.photo
                    self?.collectionView?.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentIndex = photos[indexPath.row]
        let imageUrl = generateFlickrImageURL(farm: String(currentIndex.farm), server: currentIndex.server, id: currentIndex.id, secret: currentIndex.secret)
           
        guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: imageUrl, title: currentIndex.title)
           return cell
       }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            photos = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
}


