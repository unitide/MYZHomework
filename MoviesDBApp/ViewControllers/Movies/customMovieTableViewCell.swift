//
//  customMovieTableViewCell.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import UIKit

class customMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var showDetailButton: UIButton!
    
    var cellDelegate: ShowDetailPressedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func showMovieDetail(_ sender: UIButton) {
       
        cellDelegate?.didPressButton(sender.tag)
        print("the movie ID is \(sender.tag)")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


protocol ShowDetailPressedDelegate : AnyObject {
    func didPressButton(_ tag: Int)
}
