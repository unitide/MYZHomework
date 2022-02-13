//
//  NetworkError.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case jsonEncodeError
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Bad url"
        case .jsonEncodeError:
            return "Json encode error"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
