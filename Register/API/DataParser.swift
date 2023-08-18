//
//  DataParser.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation

class DataParser {
    
    func parse<T: Decodable>(data: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        let parsedData = try jsonDecoder.decode(T.self, from: data)
        return parsedData
        
    }
}
