//
//  NetworkManager.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 23.07.2022.
//

import Foundation

class NetworkManager {
    enum RocketsError: Error {
        case parseError
        case requestError(Error)
    }
    
    static let shared = NetworkManager()
    
    func getData(completion: @escaping ((Result<[Rocket], RocketsError>) -> Void)) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spacexdata.com"
        urlComponents.path = "/v4/rockets"
        
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return completion(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let rockets = JSONDecoder()
            
            do {
                let result = try rockets.decode([Rocket].self, from: data)
                print(result)
                return completion(.success(result))
            } catch {
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    private init() {}
}
