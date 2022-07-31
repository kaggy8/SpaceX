//
//  NetworkManager.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 23.07.2022.
//

import Foundation

class NetworkManager {
    enum RocketsError: Error {
        case invalidURL
        case noData
        case decodingError
    }
    
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(dataType: T.Type ,from url: String, with completion: @escaping ((Result<T, RocketsError>) -> Void)) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: String?) -> Data? {
        guard let url = URL(string: url ?? " ") else { return nil}
        return try? Data(contentsOf: url)
    }
    
    private init() {}
}
