//
//  PhotoCollectionViewCell.swift
//  Flickr Photo Search
//
//  Created by Tewodros Mengesha on 21.3.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    private var networkService = NetworkService()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.systemBackground
        titleLabel.numberOfLines = 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        titleLabel.frame = CGRect(x: 0, y: imageView.frame.height - 50, width: imageView.frame.width, height: 60)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
    }
    
    func configure(with viewModel: PhotoCellViewModel) {
        networkService.getImage(from: viewModel.urlString) { image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
                self?.titleLabel.text = viewModel.text
            }
        }
    }
}
