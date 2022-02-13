//
//  NetworkURL.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import Foundation
struct NetworkURLs {
   // static let APIKey = "api_key=142d48e7dd566de20e630c3104b37096"
    static let APIKey = "6622998c4ceac172a976a1136b204df4"
    static let baseMovieURL = "https://api.themoviedb.org/3/movie/"
    static let popularMovieURL = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=6622998c4ceac172a976a1136b204df4"
    static let queryURLSuffix = "?language=en-US&page=1&api_key=6622998c4ceac172a976a1136b204df4"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    static let movieImageURL = "https://api.themoviedb.org/3/movie/{movie_id}/images?api_key=<<api_key>>&language=en-US"
    
    static let movieDetailURL = "https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US"
}

//634649 /568124
//https://api.themoviedb.org/3/movie/634649?api_key=6622998c4ceac172a976a1136b204df4&language=en-US
//
//https://api.themoviedb.org/3/movie/634649/images?language=en-US&page=1&api_key=6622998c4ceac172a976a1136b204df4
