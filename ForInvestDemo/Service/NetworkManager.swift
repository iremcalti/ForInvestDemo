//
//  NetworkManager.swift
//  ForInvestDemo
//
//  Created by İrem Çaltı on 17.12.2023.
//

import Foundation

enum StocksError : Error {
    case serverError
    case parsingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(type: T.Type, urlString: String, completion: @escaping (Result<T, StocksError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
        if let data {
           do {
               let dataModel = try JSONDecoder().decode(type.self, from: data)
               completion(.success(dataModel))
           
           } catch {
               completion(.failure(.parsingError))
           }
               
        } else {
            completion(.failure(.serverError))
        }
           
        }.resume()
                     
    }
    
}
