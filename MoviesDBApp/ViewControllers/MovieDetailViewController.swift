//
//  MovieDetailViewController.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/12/22.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    var movieID: Int?
    private var vm = ViewModel()
    private var movieDetail: MoviesOverview?
    private var subscribers = Set<AnyCancellable>()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var posterImAGE: UIImageView!
    
    @IBOutlet private weak var productCompanies: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
      
        // Do any additional setup after loading the view.
    }
    
    private func setupBinding() {
        vm
        .$moviesOverview
        .receive(on: RunLoop.main)
        .sink { [weak self] _ in
                self?.movieDetail
            self?.displayMovieDetail()
            }
        .store(in: &subscribers)
        
        if self.movieID != nil {
          vm.fetchMoviesData(movieID: self.movieID!)
        }
    }
    
    func displayMovieDetail() {
        titleLabel.text = movieDetail?.title
        overviewLabel.text = movieDetail?.overview
        if let image = movieDetail?.posterImage {
            posterImAGE.image = UIImage(data: image)
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
