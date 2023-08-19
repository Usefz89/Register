//
//  State.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import Foundation

struct State: Codable {
    let name: String
    let id: String
    
  
    
    
    enum CodingKeys: String, CodingKey {
        case name = "Text"
        case id = "Value"
        
    }
    
}
