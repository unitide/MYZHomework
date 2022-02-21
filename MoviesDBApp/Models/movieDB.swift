//
//  movieDB.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import Foundation

struct MoviesDB: Codable {
    let page: Int
    let results: [ResponseResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ResponseResult: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case ja = "ja"
}

struct MoviesOverview {
    let movieID: Int
    let title: String
    let overview: String
    let posterImageLink: String
    var posterImage: Data?
    var productionCompaniesLogoPath: [String]?
    var ProductionCompaniesLogoImage: [Data]?
    var favorite: Bool?
    
    init(movieID: Int, title: String,overview: String, posterImageLink: String) {
        self.movieID = movieID
        self.title = title
        self.overview = overview
        self.posterImageLink = posterImageLink
        self.posterImage = Data()
        self.productionCompaniesLogoPath = [String]()
        self.ProductionCompaniesLogoImage = [Data]()
    }
    
    init(movieID: Int, title: String,overview: String, posterImageLink: String, posterImage: Data?, productionCompaniesLogoPath: [String]? ,ProductionCompaniesLogoImage: [Data]?, favorite: Bool? ) {
        self.movieID = movieID
        self.title = title
        self.overview = overview
        self.posterImageLink = posterImageLink
        self.posterImage = posterImage
        self.productionCompaniesLogoPath = productionCompaniesLogoPath
        self.ProductionCompaniesLogoImage = ProductionCompaniesLogoImage
        self.favorite = favorite
    }
}
