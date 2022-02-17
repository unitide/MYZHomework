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
    @Published private(set) var movieDetail: MoviesOverview?
    
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
    
    
    func fetchMoviesData(movieID: Int) {
        let urlString = NetworkURLs.baseMovieURL + "\(movieID)" + NetworkURLs.queryURLSuffix
        
        networkManager.getModel(MovieDetail.self, from: urlString) { result in
            switch result {
            case .success(let movie):
                if let row = self.findRowNumber(movieID: movieID, movies: self.moviesOverview) {
                    if let productionCompanies = movie.productionCompanies {
                        for company in productionCompanies {
                            if let logo_path = company.logoPath {
                                self.moviesOverview[row].productionCompaniesLogoPath?.append(logo_path)
                                //MARK: download product company logo
                                self.networkManager.getImageData(from: NetworkURLs.baseImageURL+logo_path) { data in
                                    if let data = data {
                                        self.moviesOverview[row].ProductionCompaniesLogoImage?.append(data)
                                        print("Companies logo downloaded! Movie id \(movieID) row is \(row)")
                                    }
                                    self.movieDetail = self.moviesOverview[row]
                                }
                            }
                        }
                    }
                    self.movieDetail = self.moviesOverview[row]
                  print("row number \(row)  movie id \(movieID)")
                }
                print("I didn't find the Movie with id \(movieID)")
                return
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    func findRowNumber(movieID: Int, movies: [MoviesOverview]) -> Int? {
        for (row,movie) in movies.enumerated() {
            if movie.movieID == movieID {
                return row
            }
        }
        return nil
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
    func getChosenMovie() -> MoviesOverview? {
        if let movie = self.movieDetail {
            return movie
        }
        return nil
    }
    
    func getChosenMovieProductionLogo() -> [Data]? {
        if let data = self.movieDetail?.ProductionCompaniesLogoImage {
            return data
        }
     return nil
    }
}

