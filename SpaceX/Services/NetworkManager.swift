//
//  NetworkManager.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 23.07.2022.
//

import Foundation

class NetworkManager {
    private let urlSession = URLSession.shared
    
    func getData(completion: @escaping ([Rocket]) -> Void) {
        guard let baseUrl = URL(string: "https://api.spacexdata.com/v4/rockets") else { return }
        
        let task = urlSession.dataTask(with: baseUrl) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let result = try JSONDecoder().decode([Rocket].self, from: data)
                
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
