//
//  APIManager.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation




class APIManager {
    
    func perform(request: RequestProtocol) async throws -> Data {
        let urlRequest = try request.createURLRequest()
        
        let (data, response) =  try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
            throw NetworkError.invalidServerResponse
        }
        
        return data
    }
}


