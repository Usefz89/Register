//
//  RequestManager.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation

class RequestManager {
    let apiManager = APIManager()
    let dataParser = DataParser()
    
    
    func perform<T: Decodable>(request: RequestProtocol) async throws -> T {
        let data = try await apiManager.perform(request: request)
        let decodedData: T = try dataParser.parse(data: data)
        return decodedData
    }
}
