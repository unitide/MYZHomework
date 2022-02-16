//
//  TitelCollectionViewCell.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/16/22.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
     weak var label: UILabel!
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to initialize Movie detail collection view cell!!")
    }
    
    func setupCell() {
        let label = UILabel()
//        label.textAlignment = .center
//        label.textColor = .red
        label.numberOfLines = 0
//        label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.label = label
        
    }
}
