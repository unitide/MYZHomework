//
//  FavoriteCollectionViewCell.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/15/22.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    weak  var favorite: UISwitch!
    weak var delegate: MovieDetailViewController?
   
    override init (frame: CGRect){
        
        super.init(frame: frame)
        
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to initialize Movie detail collection view cell!!")
    }
    
 
    
    func setupCell(){
        
        let favorite = UISwitch()
        let label = UILabel()
        label.text = "Favorite"
        label.textAlignment = .right
       
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        favorite.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 15).isActive = true
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 120).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
      //  label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -100).isActive = true
        label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -15).isActive = true
        
        self.contentView.addSubview(favorite)
        favorite.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 35).isActive = true
        favorite.leadingAnchor.constraint(equalTo: label.trailingAnchor,constant: 15).isActive = true
        favorite.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -10).isActive = true
        favorite.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -15).isActive = true
       
        favorite.addTarget(self, action: #selector(favoriteClicked), for: .touchUpInside)
        self.favorite = favorite
    }
    
    @objc func favoriteClicked(){
        self.delegate?.setMoviesFavoriteStatus(status: favorite.isOn)
        
    }
}


protocol MoviesFavoriteStatusProtocol {
    func setMoviesFavoriteStatus(status: Bool)
}
