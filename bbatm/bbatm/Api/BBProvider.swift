//
//  BBProvider.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import Foundation

final class BBProvider: ObservableObject {
    @Published var atms = [BBATMResponse]()
    
    func loadAtms(completion: @escaping((_ atms: [BBATMResponse]?, _ error: Error?) -> ())) {
        guard let url = URL(string: "https://belarusbank.by/open-banking/v1.0/atms") else {
            fatalError("ERROR | Invalid URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data,
                  let root = try? JSONDecoder().decode(BBATMRootResponse.self, from: data) else {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                completion(root.parsedData.atms, nil)
            }
        }.resume()
    }
}
