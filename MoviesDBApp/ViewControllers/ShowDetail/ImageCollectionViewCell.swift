//
//  MovieCollectionViewCell.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/15/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    
    weak var image: UIImageView!
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to initialize Movie detail collection view cell!!")
    }
    
    func setupCell() {
//        let title = UILabel()
//        title.textAlignment = .center
//        title.textColor = .red
//        title.numberOfLines = 0
//        title.font.withSize(20)
//        title.translatesAutoresizingMaskIntoConstraints = false
//
//        self.contentView.addSubview(title)
//        title.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
//        title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
//        title.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        self.title = title
//
//        let overview = UILabel()
//
//        overview.textAlignment = .left
//        title.numberOfLines = 0
//        overview.font.withSize(14)
//        self.contentView.addSubview(overview)
//
//
//        overview.translatesAutoresizingMaskIntoConstraints = false
//
//        overview.topAnchor.constraint(equalTo: self.title.bottomAnchor).isActive = true
//        overview.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
//        overview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
//        overview.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        self.overview = overview
        
        let image = UIImageView()
       // image.contentMode = .scaleAspectFill
//        image.frame.size.width = 400
//        image.frame.size.width = 400
        
        self.contentView.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.image = image
    }
}
