//
//  NetworkManager.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import Foundation

class NetworkManager {
    
    func getModel<Model: Codable>(_ type: Model.Type, from url: String, completion: @escaping (Result<Model, NetworkError>) -> ()) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(type, from: data)
                    completion(.success(response))
                }  catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let error {
                    completion(.failure(.other(error)))
                }
            }
        }
        .resume()
        
    }
    
    func getImageData(from url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data)
        }
        .resume()
    }
}
