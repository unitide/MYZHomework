//
//  ViewModel.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/12/22.
//

import UIKit
import Combine

class ViewModel {
    private  var networkManager = NetworkManager()
    @Published private(set) var moviesOverview = [MoviesOverview]()
    
    func fetchMoviesData() {
        
        networkManager.getModel(MoviesDB.self, from: NetworkURLs.popularMovieURL) { result in
            switch result {
            case .success(let movies):
                for movie in movies.results {
                    let mo = MoviesOverview(movieID: movie.id, title: movie.title, overview: movie.overview,posterImageLink: movie.posterPath)
                    self.moviesOverview.append(mo)

                }
                // MARK: down poster image
                for (index,movie) in self.moviesOverview.enumerated() {
                    let imageURL = NetworkURLs.baseImageURL + movie.posterImageLink
                    self.networkManager.getImageData(from: imageURL) { data in
                        self.moviesOverview[index].posterImage = data
                    }

                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        

    }
    
    func getMovieTitleByRow(row: Int) -> String {
         moviesOverview[row].title
    }
    
    func getMovieOverviewByRow(row: Int) -> String {
         moviesOverview[row].overview
    }
    
    func getMoviePosterImageByRow(row: Int) -> Data? {
         moviesOverview[row].posterImage
    }
    
    func getMovieIDByRow(row: Int) -> Int {
         moviesOverview[row].movieID
    }
    
    func getTotalMovies() -> Int  {
        moviesOverview.count
    }
}

