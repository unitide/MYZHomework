//
//  ViewModel.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/12/22.
//

import UIKit
import Combine
import CoreData

enum UserOptions: Int {
    case FromNetork = 0
    case FromFavorite
    case FromSearch
}

class ViewModel {
    
    private  var networkManager = NetworkManager()
    @Published private(set) var moviesOverview = [MoviesOverview]()
    @Published private(set) var movieDetail: MoviesOverview?
   // var movieDetail = PassthroughSubject<MoviesOverview,Never>()
    
    private var currentPage = 1
    
    
    
    private var favoriteMovies = [Int:MoviesOverview]()
    private var moviesOverviewFromNetork = [MoviesOverview]()
    
    
    func loadMoviePage () {
        fetchOnePageMoviesData(page: currentPage)
        currentPage += 1
        
    }
    
    
    private func fetchOnePageMoviesData(page: Int) {
        let popularMovieURL = NetworkURLs.popularMovieBaseURL + "\(page)" + NetworkURLs.APIKey
        networkManager.getModel(MoviesDB.self, from: popularMovieURL) { result in
            switch result {
            case .success(let movies):
                for movie in movies.results {
                    let mo = MoviesOverview(movieID: movie.id, title: movie.title, overview: movie.overview,posterImageLink: movie.posterPath)
                    self.moviesOverview.append(mo)
                    self.moviesOverviewFromNetork.append(mo)

                }
                // MARK: down poster image
                for (index,movie) in self.moviesOverview.enumerated() {
                    let imageURL = NetworkURLs.baseImageURL + movie.posterImageLink
                    self.networkManager.getImageData(from: imageURL) { data in
                        self.moviesOverview[index].posterImage = data
                        self.moviesOverviewFromNetork[index].posterImage = data
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
                                self.moviesOverviewFromNetork[row].productionCompaniesLogoPath?.append(logo_path)
                                
                                //MARK: download product company logo
                                self.networkManager.getImageData(from: NetworkURLs.baseImageURL+logo_path) { data in
                                    if let data = data {
                                        self.moviesOverview[row].ProductionCompaniesLogoImage?.append(data)
                                        self.moviesOverviewFromNetork[row].ProductionCompaniesLogoImage?.append(data)
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
    
   
    func displayMovies(userOption: UserOptions,movie :String? = "") {
        switch userOption {
        case .FromNetork:
            self.moviesOverview = self.moviesOverviewFromNetork.map{$0}
            
        case .FromFavorite:
            self.moviesOverview.removeAll()
            for (_,movie) in self.favoriteMovies {
                self.moviesOverview.append(movie)
            }
            
        case .FromSearch:
           
            guard let movie = movie else {
                print("I am here")
                self.moviesOverview = self.moviesOverviewFromNetork.map{$0}
                return
            }
            if movie.count == 0 {
                self.moviesOverview = self.moviesOverviewFromNetork.map{$0}
            } else {
                self.moviesOverview = self.moviesOverviewFromNetork.compactMap{ $0.title.lowercased().contains(movie.lowercased()) ? $0: nil }
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
    
    func getMovieDetailFavoriteStatus() -> Bool? {
        if let movieID = self.movieDetail?.movieID {
            return self.favoriteMovies[movieID]?.favorite
        }
        return false
    }
    
    func setMovieDetailFavoriteStatus(status: Bool)  {
         self.movieDetail?.favorite =  status
        if status {
            if let movieID = self.movieDetail?.movieID {
                favoriteMovies[movieID] = self.movieDetail
            }
        } else {
            if let movieID = self.movieDetail?.movieID {
                favoriteMovies[movieID] = nil
            }
        }
    }


// MARK: The following code is favorite movies data management storing in the core data

    private func deleteAllFavoriteMoiesFromCoreData () {
        let request: NSFetchRequest = MovieOverviewDescption.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        do {
            let allFavoriteMovies = try context.fetch(request)
            for movie in allFavoriteMovies {
                context.delete(movie)
            }
            CoreDataManager.shared.saveContext()
            
        } catch {
            print(error)
        }
        
    }
    
    private func fetchAllFavoriteMovieDataFromCoreData() -> [Int:MoviesOverview] {
        let request: NSFetchRequest = MovieOverviewDescption.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        
        var movies = [Int:MoviesOverview]()
        
        do {
            let favoriteMovies = try context.fetch(request)
            
            for movie in favoriteMovies {
          
               
                let movieID = movie.value(forKey: "moviesID") as! Int
                let title = movie.value(forKey: "title") as! String
                
                 let overview = movie.value(forKey: "overview") as! String
                 let posterImage = movie.value(forKey: "posterImage") as! Data
                 let posterImageLink = movie.value(forKey: "posterImageLink") as! String
                 let productionCompaniesLogoImage = movie.value(forKey: "productionCompaniesLogoImage") as! [Data]
                 let productionCompaniesLogoPath = movie.value(forKey: "productionCompaniesLogoPath") as! [String]
                 let favorite = movie.value(forKey: "favorite") as! Bool
               
                
                movies[movieID] = MoviesOverview(movieID: movieID, title: title, overview: overview, posterImageLink: posterImageLink, posterImage: posterImage, productionCompaniesLogoPath: productionCompaniesLogoPath, ProductionCompaniesLogoImage: productionCompaniesLogoImage, favorite: favorite)
            }
            return movies
        } catch let error {
            print(error)
        }
        return movies
    }

    private func saveFavoriteMovieDataToCoreData(_ favoriteMovies: [Int:MoviesOverview]) {
    
        let context = CoreDataManager.shared.mainContext
        
        guard let description = NSEntityDescription.entity(forEntityName: "MovieOverviewDescption", in: context)
        else { return }
        
        for (_,favoriteMovie) in favoriteMovies {
            let movieForSave = MovieOverviewDescption(entity: description, insertInto: context)
            movieForSave.moviesID = Int64(favoriteMovie.movieID)
            movieForSave.title = favoriteMovie.title
            movieForSave.overview = favoriteMovie.overview
            movieForSave.posterImageLink = favoriteMovie.posterImageLink
            movieForSave.posterImage = favoriteMovie.posterImage
            movieForSave.productionCompaniesLogoPath = favoriteMovie.productionCompaniesLogoPath as NSArray?
            movieForSave.productionCompaniesLogoImage = favoriteMovie.ProductionCompaniesLogoImage as NSArray?
            movieForSave.favorite = favoriteMovie.favorite ?? false
        }
        CoreDataManager.shared.saveContext()
    }
    
    func loadFavoriteMovies() {
        self.favoriteMovies = fetchAllFavoriteMovieDataFromCoreData()
     //   self.deleteAllFavoriteMoiesFromCoreData()
    }
    
    func saveFavoriteMovies() {
        self.deleteAllFavoriteMoiesFromCoreData()
        self.saveFavoriteMovieDataToCoreData(self.favoriteMovies)
    }
    
}
